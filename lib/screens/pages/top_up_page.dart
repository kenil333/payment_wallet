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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            BlocBuilder<AppCubit, CubitState>(
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
                    child: (isloading)
                        ? const Center(
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: spinkit,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).padding.top + 15,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: size.width * 0.05,
                                      right: size.width * 0.05),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            borderRadius:
                                                BorderRadius.circular(9),
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
                                      AppText(
                                          text: 'Top Up', colour: Colors.black)
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  width: size.width,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1, color: Colors.black87),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Container(
                                      //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                      //   child: Column(
                                      //     children: [
                                      //       const Text("Enter the Amount:", style: TextStyle(fontSize: 17, color: Colors.black87),),
                                      //       // TextField(
                                      //       //   controller: amountController,
                                      //       //   keyboardType:
                                      //       //   TextInputType.number,
                                      //       //   style: const TextStyle(
                                      //       //       fontSize: 18.0,
                                      //       //       color: Colors.black),
                                      //       //   decoration: const InputDecoration(
                                      //       //       hintText: 'Amount',
                                      //       //       hintStyle:
                                      //       //       TextStyle(
                                      //       //           fontSize: 16,
                                      //       //           color: Colors
                                      //       //               .black54),
                                      //       //       labelStyle:
                                      //       //       TextStyle(
                                      //       //           fontSize: 16.0,
                                      //       //           color: Colors
                                      //       //               .black54)),
                                      //       // ),
                                      //     ],
                                      //   ),
                                      // ),
                                      Container(
                                        width: size.width * 0.4,
                                        height: size.height * 0.08,
                                        // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                        // color: AppColours.buttoncolor.withOpacity(0.8),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(8),
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/netwest.png"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Topping up text
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: AppLargeText(
                                    text: 'Topping up ' + bankName,
                                    size: 22,
                                    colour: Colors.black87,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                //Card Balance
                                Container(
                                  // height: size.width * 0.23,
                                  width: size.width * 0.9,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 2),
                                            color: Colors.grey.shade300,
                                            blurRadius: 3,
                                            spreadRadius: 2),
                                      ]),
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 10),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppText(
                                              text: 'Your Balance:',
                                              colour: Colors.black,
                                              size: 17),
                                          const SizedBox(height: 7),
                                          AppText(
                                            text: getCurrencyAmount(
                                                context,
                                                state.account.currency,
                                                state.account.balance),
                                            colour: Colors.black,
                                            weight: FontWeight.w600,
                                            size: 18,
                                          ),
                                        ],
                                      )),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //AUD balance
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Row(
                                        children: [
                                          AppText(
                                            text: 'Available fund: AUD ',
                                            size: 17,
                                            colour: Colors.black,
                                          ),
                                          AppText(
                                            text: getCurrencyAmount(
                                                context,
                                                mainAccount.currency,
                                                mainAccount.balance),
                                            size: 18,
                                            colour: Colors.black,
                                            weight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: 80,
                                          width: size.width * 0.32,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/Lightning.gif"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              height: size.width * 0.29,
                                              width: size.width * 0.3,
                                              padding: const EdgeInsets.all(5),
                                              child: Stack(
                                                alignment: Alignment.topCenter,
                                                children: [
                                                  Container(
                                                    height: size.width * 0.24,
                                                    width: size.width * 0.24,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: AppColours
                                                              .buttoncolor),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          mainAccount.bankName,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.0255,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Text(
                                                          "From",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    child: Container(
                                                      height: size.width * 0.08,
                                                      width: size.width * 0.25,
                                                      // margin: const EdgeInsets.only(bottom: 10),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: AppColours
                                                            .buttoncolor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Text(
                                                        mainAccount.currency,
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: size.width * 0.29,
                                              width: size.width * 0.3,
                                              padding: const EdgeInsets.all(5),
                                              child: Stack(
                                                alignment: Alignment.topCenter,
                                                children: [
                                                  Container(
                                                    height: size.width * 0.24,
                                                    width: size.width * 0.24,
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: AppColours
                                                              .buttoncolor),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          account.bankName,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.0255,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Text(
                                                          "To",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    child: Container(
                                                      height: size.width * 0.08,
                                                      width: size.width * 0.25,
                                                      // margin: const EdgeInsets.only(bottom: 10),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: AppColours
                                                            .buttoncolor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Text(
                                                        account.currency,
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    //Enter amount
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.width * 0.025,
                                          horizontal: size.width * 0.05),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                  text: 'Enter the amount: ',
                                                  colour: Colors.black,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  controller: resController,
                                                  style: const TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                      borderSide:
                                                      const BorderSide(
                                                          color:
                                                          Colors.black),
                                                    ),
                                                    hintText: '0.00',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black54),
                                                    labelStyle: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black87
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.05,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                    text: 'Final Amount ' +
                                                        getCurrency(
                                                            context,
                                                            state.account
                                                                .currency),
                                                    colour: Colors.black87),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  controller: resController,
                                                  style: const TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    hintText: '0.00',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black54),
                                                    labelStyle: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black87
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    //Fees and amount detail
                                    Container(
                                      width: size.width * 0.9,
                                      // height: size.height * 0.26,
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color(0xff50B2FA),
                                      ),
                                      child: Container(
                                        width: size.width * 0.9,
                                        // height: size.height * 0.26,
                                        margin: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          // color: const Color(0xFFEBF4F8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            StreamBuilder<RateData>(
                                              stream: generateRateStream(
                                                  state.account.currency),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  Rate rateData =
                                                      snapshot.data!.rate;
                                                  rate = rateData.rate;
                                                  //res = _getConversionAmount(rate);
                                                  _updateFinalAmount();
                                                  return Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 12,
                                                        horizontal: 18),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            text:
                                                                'Exchange rate: ',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.width *
                                                                      0.035,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: getCurrencyAmount(
                                                                        context,
                                                                        mainAccount
                                                                            .currency,
                                                                        1.00) +
                                                                    ' is ' +
                                                                    getCurrencyAmount(
                                                                        context,
                                                                        state
                                                                            .account
                                                                            .currency,
                                                                        rateData
                                                                            .rate),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        size.width *
                                                                            0.035,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 3),
                                                        RichText(
                                                          text: TextSpan(
                                                            text: 'Fees: ',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.width *
                                                                      0.035,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'AUD 0.00',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        size.width *
                                                                            0.035,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 3),
                                                        RichText(
                                                          text: TextSpan(
                                                            text:
                                                                'Total Fees: ',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.width *
                                                                      0.035,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'AUD 0.00',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        size.width *
                                                                            0.035,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                    "Error: " +
                                                        "${snapshot.error}",
                                                    style: const TextStyle(
                                                        color: Colors.white70),
                                                  );
                                                }
                                                return const SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: spinkit,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: GestureDetector(
                                          onTap: () async {
                                            if (amountController.text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "please enter amount "),
                                                ),
                                              );
                                            } else {
                                              isloading = true;
                                              setState(() {});
                                              print('Old Balance : ' +
                                                  '$balance');
                                              String response =
                                                  await postTransfer(
                                                      state.account.bankName,
                                                      state.account
                                                          .identification,
                                                      amountController.text,
                                                      'Top-up: ' +
                                                          amountController
                                                              .text);
                                              balance += finalAmount;
                                              print('Balance: ' + '$balance');
                                              state.account.balance = balance;
                                              mainAccount.balance -=
                                                  double.parse(
                                                      amountController.text);
                                              print('NAB balance :' +
                                                  mainAccount.balance
                                                      .toStringAsFixed(2));
                                              isloading = false;
                                              setState(() {});
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context1) {
                                                    return alert(
                                                      context,
                                                      response,
                                                      mainAccount,
                                                      state.account,
                                                      state.index,
                                                      size,
                                                    );
                                                  });
                                              debugPrint(
                                                  "goto card detail page");
                                            }
                                          },
                                          child: Container(
                                            width: size.width,
                                            height: 45,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColours.buttoncolor,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: AppText(
                                              text: 'Top Up',
                                              colour: Colors.white,
                                              size: 20,
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ]),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
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
