import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/data/spinkit/spinkit.dart';
import 'package:tensopay_wallet_prototype/models/rate.dart';
import 'package:tensopay_wallet_prototype/models/rate_data.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/data_generator.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_constants.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

import '../../models/bank.dart';
import '../../widgets/tenso_input_decoration.dart';
import '../../widgets/tenso_large_text.dart';

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

  bool isloading = false;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    amountController.addListener(_updateFinalAmount);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AppCubit, CubitState>(
        builder: (context, state) {
          if (state is TopUpState) {
            var bankName = state.account.bankName;
            var mainAccount = state.mainAccount;
            var account = state.account;
            var index = state.index;
            balance = state.account.balance;
            print(state.account.identification);
            return ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top + 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: size.width * 0.05,
                          right: size.width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<AppCubit>(context)
                                  .goToMainPage(0);
                            },
                            child: Container(
                              height: size.width * 0.1,
                              width: size.width * 0.1,
                              decoration: BoxDecoration(
                                color: AppColours.buttoncolor,
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(
                                    width: 0.5,
                                    color: AppColours.buttoncolor),
                              ),
                              child: const Icon(
                                Icons.arrow_back_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          AppText(text: 'Top Up', colour: Colors.black)
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Container(
                      width: size.width,
                      height: size.height * 0.075,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            width: 1,
                            color: Colors.black54.withOpacity(0.4)),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Enter the Amount:",
                                  style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      color: Colors.black54),
                                ),
                                SizedBox(
                                  height: size.height * 0.002,
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(bottom: size.width * 0.007),
                                  width: size.width * 0.45,
                                  height: size.height * 0.045,
                                  child: TextField(
                                    controller: amountController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        fontSize: size.width * 0.045,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Amount',
                                      hintStyle: TextStyle(
                                          fontSize: size.width * 0.042,
                                          color: Colors.black87.withOpacity(0.8)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: size.width * 0.32,
                            height: size.height * 0.075,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  (mainAccount.bankName == "NAB")
                                      ? "assets/images/nab.png"
                                      : (mainAccount.bankName ==
                                              "NatWest")
                                          ? "assets/images/netwest.png"
                                          : (mainAccount.bankName ==
                                                  "CIBC")
                                              ? "assets/images/cibc.png"
                                              : "assets/images/itau.png",
                                ),
                                fit: BoxFit.fill,
                              ),
                              color: AppColours.buttoncolor,
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<RateData>(
                        stream: generateRateStream(
                            state.account.currency),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Rate rateData = snapshot.data!.rate;
                            rate = rateData.rate;
                            //res = _getConversionAmount(rate);
                            _updateFinalAmount();
                            return Stack(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: size.width * 0.1),
                                          padding: EdgeInsets.only(top: size.height * 0.01),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                width: 2, color: Colors.grey.withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: size.width * 0.07,
                                                  ),
                                                  AppText(
                                                    text: 'Available fund: ',
                                                    size: size.width * 0.04,
                                                    colour: Colors.black54,
                                                  ),
                                                  AppText(
                                                    text: getCurrencyAmount(
                                                        context,
                                                        mainAccount.currency,
                                                        mainAccount.balance),
                                                    size: size.width * 0.045,
                                                    colour: AppColours.buttoncolor.withOpacity(0.9),
                                                    weight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: size.height * 0.009,),
                                              Container(
                                                height: 1,
                                                width: size.width * 0.6,
                                                color: Colors.grey.withOpacity(0.6),
                                                margin: EdgeInsets.only(
                                                    left: size.width * 0.05),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: size.width * 0.094,
                                          top: size.width * 0.034,
                                          child: Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(40),
                                              color: Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: size.width * 0.1),
                                          padding: EdgeInsets.symmetric(vertical: size.height * 0.008),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                width: 2, color: Colors.grey.withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.07,
                                              ),
                                              AppText(
                                                text: 'Exchange rate: ',
                                                size: size.width * 0.038,
                                                colour: Colors.black87.withOpacity(0.4),
                                              ),
                                              AppText(
                                                text: getCurrencyAmount(
                                                    context,
                                                    mainAccount.currency,
                                                    1.00) +
                                                    ' is ' +
                                                    getCurrencyAmount(
                                                        context,
                                                        state.account.currency,
                                                        rateData.rate),
                                                size: size.width * 0.041,
                                                colour: Colors.black87.withOpacity(0.7),
                                                weight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: size.width * 0.094,
                                          top: size.width * 0.031,
                                          child: Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(40),
                                              color: Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: size.width * 0.1),
                                          padding: EdgeInsets.symmetric(vertical: size.height * 0.008),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                width: 2, color: Colors.grey.withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.07,
                                              ),
                                              AppText(
                                                text: 'Fees: ',
                                                size: size.width * 0.038,
                                                colour: Colors.black87.withOpacity(0.5),
                                              ),
                                              AppText(
                                                text: "AUD 0.00",
                                                size: size.width * 0.041,
                                                colour: Colors.black87.withOpacity(0.7),
                                                weight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: size.width * 0.094,
                                          top: size.width * 0.031,
                                          child: Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(40),
                                              color: Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: size.width * 0.1),
                                          padding: EdgeInsets.symmetric(vertical: size.height * 0.008),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                width: 2, color: Colors.grey.withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.07,
                                              ),
                                              AppText(
                                                text: 'Total Fees: ',
                                                size: size.width * 0.038,
                                                colour: Colors.black54.withOpacity(0.5),
                                              ),
                                              AppText(
                                                text: "AUD 0.00",
                                                size: size.width * 0.041,
                                                colour: Colors.black87.withOpacity(0.7),
                                                weight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: size.width * 0.094,
                                          top: size.width * 0.031,
                                          child: Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(40),
                                              color: Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: size.width * 0.1),
                                          padding: EdgeInsets.only(bottom: size.height * 0.01),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                width: 2, color: Colors.grey.withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 1,
                                                width: size.width * 0.6,
                                                color: Colors.grey.withOpacity(0.6),
                                                margin: EdgeInsets.only(
                                                    left: size.width * 0.05),
                                              ),
                                              SizedBox(height: size.height * 0.009,),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: size.width * 0.07,
                                                  ),
                                                  AppText(
                                                    text: 'Your Balance: ',
                                                    size: size.width * 0.04,
                                                    colour: Colors.black54,
                                                  ),
                                                  AppText(
                                                    text: getCurrencyAmount(
                                                        context,
                                                        state.account.currency,
                                                        state.account.balance),
                                                    size: size.width * 0.045,
                                                    colour: AppColours.buttoncolor.withOpacity(0.9),
                                                    weight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: size.width * 0.094,
                                          top: size.width * 0.034,
                                          child: Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(40),
                                              color: Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              "Error: " + "${snapshot.error}",
                              style: const TextStyle(
                                  color: Colors.white70),
                            );
                          }
                          return Container(
                            height: size.height * 0.185,
                            width: size.width,
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: 60,
                              height: 60,
                              child: spinkit,
                            ),
                          );
                        }),
                    Container(
                      width: size.width,
                      height: size.height * 0.075,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(width: 1, color: Colors.black54.withOpacity(0.4)),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Recipient gets exactly:",
                                  style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      color: Colors.black54),
                                ),
                                SizedBox(
                                  height: size.height * 0.002,
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(bottom: size.width * 0.008),
                                  width: size.width * 0.45,
                                  height: size.height * 0.045,
                                  child: TextField(
                                    enabled: false,
                                    controller: resController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        fontSize: size.width * 0.045,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '0.00',
                                        hintStyle: TextStyle(
                                            fontSize: size.width * 0.042,
                                            color: Colors.black87.withOpacity(0.8)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: size.width * 0.32,
                            height: size.height * 0.075,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            decoration: BoxDecoration(
                              color: AppColours.buttoncolor,
                              image: DecorationImage(
                                image: AssetImage(
                                  (account.bankName == "NAB")
                                      ? "assets/images/nab.png"
                                      : (account.bankName ==
                                      "NatWest")
                                      ? "assets/images/netwest.png"
                                      : (account.bankName ==
                                      "CIBC")
                                      ? "assets/images/cibc.png"
                                      : "assets/images/itau.png",
                                ),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          if (amountController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("please enter amount "),
                              ),
                            );
                          } else {
                            BlocProvider.of<AppCubit>(context).goToConfirm(
                                mainAccount,
                                account,
                                index,
                                amountController.text,
                                resController.text);
                          }
                        },
                        child: Container(
                          height: size.height * 0.055,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: AppColours.buttoncolor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          alignment: Alignment.center,
                          child: const Text(
                            "Top Up",
                            style: TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ]),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void _updateFinalAmount() {
    if (rate == 0) {
      resController.value = const TextEditingValue(text: '0.00');
    } else {
      if (amountController.text.isNotEmpty) {
        resController.value =
            TextEditingValue(text: _getConversionAmount().toStringAsFixed(2));
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
  Future.delayed(const Duration(minutes: 1)); // 1 request per 60 seconds
  //print('Generating stream..');
  Rate rate = await getRate(currency);
  yield RateData(rate: rate);
}

Widget alert(BuildContext context, String response, TensoAccount mainAccount,
    TensoAccount account, int index, Size size) {
  Hive.box<TensoAccount>(tenso_db_box).putAt(index, account);
  int? mainAccount_index = findMainAccountIndex();
  Hive.box<TensoAccount>(tenso_db_box).putAt(mainAccount_index!, mainAccount);
  return Center(
    child: Container(
      padding: const EdgeInsets.all(20),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          (response == "Successful")
              ? Image(
                  image: const AssetImage("assets/images/success.gif"),
                  height: size.width * 0.2,
                  width: size.width * 0.2,
                  fit: BoxFit.contain,
                )
              : Image(
                  image: const AssetImage("assets/images/failure.gif"),
                  height: size.width * 0.2,
                  width: size.width * 0.2,
                  fit: BoxFit.contain,
                ),
          const SizedBox(
            height: 20,
          ),
          Text(
            response,
            style: TextStyle(
                fontSize: size.width * 0.07,
                color: AppColours.buttoncolor,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  BlocProvider.of<AppCubit>(context)
                      .goToCardDetailPage(mainAccount, account, index);
                },
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      ),
    ),
  );
  //   AlertDialog(
  //   title: Image(image: const AssetImage("assets/images/transaction.png"),height: size.width * 0.2, width: size.width * 0.2, fit: BoxFit.contain),
  //   content: Text(response, style: TextStyle(fontSize: size.width * 0.07, color: (response == "Successful") ? Colors.green : Colors.red, fontWeight: FontWeight.w600),),
  //   alignment: Alignment.center,
  //   actions: [
  //     TextButton(
  //       onPressed: () {
  //         Navigator.pop(context);
  //         BlocProvider.of<AppCubit>(context)
  //             .goToCardDetailPage(mainAccount, account, index);
  //       },
  //       child: const Text("Done"),
  //     ),
  //   ],
  // );
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
    duration: const Duration(days: 1),
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
