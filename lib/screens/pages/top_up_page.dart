import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/models/nab_account_balance.dart';
import 'package:tensopay_wallet_prototype/models/rate.dart';
import 'package:tensopay_wallet_prototype/models/rate_data.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_constants.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({Key? key}) : super(key: key);

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController resController = TextEditingController();

  String res = '';
  double balance = 0;
  double rate = 0;
  double finalAmount = 0;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    amountController.addListener(_updateFinalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<AppCubit, CubitState>(
      builder: (context, state) {
        if (state is TopUpState) {
          var bankName = state.account.bankName;
          var mainAccount = state.mainAccount;
          balance = state.account.balance;
          print(state.account.identification);
          return SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 70),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    BlocProvider.of<AppCubit>(context)
                                        .goToMainPage(0);
                                  },
                                  icon: Icon(Icons.menu)),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: AppText(
                                    text: 'Top Up',
                                    colour: Colors.black54.withOpacity(0.8)),
                              )
                            ])),
                    SizedBox(height: 20),
                    //Topping up text
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: AppText(text: 'Topping up ' + bankName),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    //Card Balance
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColours.mainColour,
                      ),
                      margin: const EdgeInsets.only(left: 20),
                      child: Container(
                          margin: const EdgeInsets.only(top: 30, left: 20),
                          child: AppText(
                            text: 'Your current balance : ' + getCurrencyAmount(context, state.account.currency, state.account.balance),
                                /*
                                '${state.account.currency}' +
                                ' ' +
                                '${state.account.balance}',

                                 */
                            colour: Colors.white,
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        child: Column(
                      children: [
                        //AUD balance
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: AppText(
                            text: 'Available fund: AUD ' +
                                //mainAccount.balance.toStringAsFixed(2),
                            getCurrencyAmount(context, mainAccount.currency, mainAccount.balance)
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        //Enter amount
                        Container(
                          //width: double.maxFinite,
                          child: Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: AppText(text: 'Enter the amount: ')),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      //fontWeight: FontWeight.w700,
                                      color: Colors.black54),
                                  decoration: InputDecoration(
                                      hintText: 'Amount',
                                      labelStyle: TextStyle(
                                          fontSize: 16.0, color: Colors.black54)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //Fees and amount detail
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: Column(
                            children: [
                              StreamBuilder<RateData>(
                                stream: generateRateStream(state.account.currency),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    Rate rateData = snapshot.data!.rate;
                                     rate = rateData.rate;
                                    //res = _getConversionAmount(rate);
                                    _updateFinalAmount();
                                    return Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: [
                                          AppText(text: 'Exchange rate :'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          AppText(
                                              text:getCurrencyAmount(context, mainAccount.currency, 1.00)+ ' is '+
                                                  getCurrencyAmount(context, state.account.currency, rateData.rate)),
                                          AppText(text: 'Fees: AUD 0.00'),
                                          AppText(text: 'Total fees: AUD 0.00 '),
                                          SizedBox(height: 10,),
                                          AppText(text: 'Top up amount:'),
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:const EdgeInsets.only(left: 20),
                                                  child: AppText(
                                                      text: 'Final Amount '+ getCurrency(context, state.account.currency)),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 20),
                                                    child: TextField(
                                                        controller: resController,
                                                        decoration: InputDecoration(
                                                            hintText: '0.00',
                                                            labelStyle: TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors
                                                                    .black54
                                                                    .withOpacity(
                                                                        0.8)))),
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("Error: " + "${snapshot.error}");
                                  }
                                  return SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              print('Old Balance : '+'$balance');
                              String response = await postTransfer(
                                  state.account.bankName,
                                  state.account.identification,
                                  amountController.text,
                              'Top-up: '+amountController.text);
                              balance += finalAmount;
                              print('Balance: ' + '$balance');
                              state.account.balance = balance;
                              mainAccount.balance -=
                                  double.parse(amountController.text);
                              print('NAB balance :' +
                                  mainAccount.balance.toStringAsFixed(2));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  _createSnackBar(context, response, mainAccount,
                                      state.account, state.index));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue.withOpacity(0.8)),
                              width: 60,
                              height: 30,
                              child: Center(
                                  child: AppText(
                                text: 'Top Up',
                              )),
                            ))
                      ],
                    )),
                  ]),
            ),
          );
        } else {
          return Container();
        }
      },
    ));
  }

  void _updateFinalAmount() {
    if (rate == 0) {
      resController.value =
          TextEditingValue(text: '0.00');
    } else {
      if (amountController.text.isNotEmpty) {
        resController.value = TextEditingValue(
            text: _getConversionAmount().toStringAsFixed(2));
      }
    }
  }

  double _getConversionAmount() {
    double amount = double.parse(amountController.text);
    finalAmount = amount * rate;
    return amount * rate;
  }
}

Stream<RateData> generateRateStream(String currency) async* {
  Future.delayed(Duration(minutes: 1)); // 1 request per 60 seconds
  //print('Generating stream..');
  Rate rate = await getRate(currency);
  yield RateData(rate: rate);
}

SnackBar _createSnackBar(BuildContext context, String response,
    TensoAccount mainAccount, TensoAccount account, int index) {
  //Update the db.
  Hive.box<TensoAccount>(tenso_db_box).putAt(index, account);
  int? mainAccount_index = findMainAccountIndex();
  Hive.box<TensoAccount>(tenso_db_box).putAt(mainAccount_index!, mainAccount);
  //Persisting snackbar
  return SnackBar(
    content: Text(response),
    action: SnackBarAction(
      label: 'Done',
      onPressed: () {
        BlocProvider.of<AppCubit>(context)
            .goToCardDetailPage(mainAccount, account, index);
        // Some code to undo the change.
      },
    ),
    duration: Duration(days: 1),
  );
}

/*
                  FutureBuilder(
                    future: getNABData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<NABAccountBalance> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            //AUD balance
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: AppText(
                                text: 'Available fund: AUD ' +
                                    snapshot!.data!.currentBalance,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            //Enter amount
                            Container(
                              //width: double.maxFinite,
                              child: Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child:
                                          AppText(text: 'Enter the amount: ')),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          //fontWeight: FontWeight.w700,
                                          color: Colors.black54),
                                      decoration: InputDecoration(
                                          hintText: 'Amount',
                                          labelStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black54)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            //Fees and amount detail
                            Container(
                              width: MediaQuery.of(context).size.width - 40,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              child: Column(
                                children: [
                                  StreamBuilder<RateData>(
                                    stream: generateRateStream(state.account.currency),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Rate rateData = snapshot.data!.rate;
                                        rate = rateData.rate;
                                        //res = _getConversionAmount(rate);
                                        _updateRate();
                                        return Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: Column(
                                            children: [
                                              AppText(text:'Exchange rate :'),
                                              SizedBox(height: 10,),
                                              AppText(text: '1 AUD is '+rateData.rate.toStringAsFixed(2) +' '+ state.account.currency ),
                                              AppText(text: 'Fees: AUD 0.00'),
                                              AppText(text: 'Total fees: AUD 0.00 '),
                                              AppText(text: 'Top up amount:'),
                                              Container(child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 20),
                                                      child: TextField(controller: resController,decoration: InputDecoration(
                                                          hintText: '0.00 '+ state.account.currency ,
                                                          labelStyle: TextStyle(
                                                              fontSize: 16.0,
                                                              color: Colors.black54.withOpacity(0.8)))),
                                                    ),
                                                  ),
                                                  AppText(text: state.account.currency),
                                                  SizedBox(width: 20,)
                                                ],
                                              ),),

                                            ],
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            "Error: " + "${snapshot.error}");
                                      }
                                      return SizedBox(width:20, height: 20,child: CircularProgressIndicator());
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(onPressed: () async {
                              String response = await postTransfer(state.account.bankName, state.account.identification, amountController.text);
                              balance += double.parse(amountController.text);
                              print('Balance: '+ '$balance');
                              state.account.balance = balance;
                              ScaffoldMessenger.of(context).showSnackBar(_createSnackBar(response,state.account, state.index));
                            },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blue.withOpacity(0.8)
                                  ),
                                  width: 60,
                                  height: 30,
                                  child: Center(child: AppText(text:'Top Up',)),
                                ))
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return AppText(text: 'Error: ${snapshot.error}');
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Awaiting result...'),
                            )
                          ],
                        );
                      }
                    },
                  ),
                       */