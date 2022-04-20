import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tensopay_wallet_prototype/data/spinkit/spinkit.dart';
import 'package:tensopay_wallet_prototype/data/stream/boolstream.dart';
import 'package:tensopay_wallet_prototype/main.dart';
import 'package:tensopay_wallet_prototype/models/tenso_payment_data.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/responsive_button.dart';
import 'package:tensopay_wallet_prototype/widgets/square_button.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_large_text.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

import '../../cubit/app_cubit_states.dart';
import '../../cubit/app_cubits.dart';
import '../../models/rate.dart';
import '../../models/rate_data.dart';
import '../../models/tenso_bank_account.dart';

class ConfirmPaymentPage extends StatefulWidget {
  const ConfirmPaymentPage({Key? key}) : super(key: key);

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  double rate = 0;
  double finalAmount = 0;
  final TextEditingController resController = TextEditingController();
  final bs = BoolStream();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<AppCubit, CubitState>(
      builder: (context, state) {
        if (state is ConfirmPaymentState) {
          TensoAccount mainAccount = state.mainAccount;
          TensoPayment payment = state.tensoPayment;
          return Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 25,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<AppCubit>(context).goToMainPage(0);
                    },
                    child: Container(
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      margin: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: AppColours.buttoncolor,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                            width: 0.5, color: AppColours.buttoncolor),
                      ),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  width: size.width,
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLargeText(
                          text: 'Payment Confirmation',
                          size: 21,
                          colour: Colors.black87.withOpacity(0.7),
                          weight: FontWeight.w600),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Container(
                        // height: size.height * 0.05,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        // margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 1, color: Colors.black87.withOpacity(0.4)),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Amount You Pay: ",
                              style: TextStyle(
                                  fontSize: size.width * 0.038,
                                  color: Colors.black87.withOpacity(0.6)),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            Text(
                              getCurrencyAmount(
                                  context, payment.currency, payment.amount),
                              style: TextStyle(
                                  fontSize: size.width * 0.043,
                                  color:
                                      AppColours.buttoncolor.withOpacity(0.9),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<RateData>(
                          stream: generateRateStream(payment.currency),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Rate rateData = snapshot.data!.rate;
                              rate = rateData.rate;
                              finalAmount = payment.amount / rate;
                              resController.value = TextEditingValue(
                                  text: getCurrencyAmount(context,
                                      mainAccount.currency, finalAmount));
                              return Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.05),
                                            padding: EdgeInsets.only(
                                                top: size.height * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * 0.1,
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
                                                      colour: AppColours
                                                          .buttoncolor
                                                          .withOpacity(0.9),
                                                      weight: FontWeight.w600,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.009,
                                                ),
                                                Container(
                                                  height: 1,
                                                  width: size.width * 0.6,
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
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
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.05),
                                            padding: EdgeInsets.only(
                                                top: size.height * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * 0.1,
                                                    ),
                                                    AppText(
                                                      text: 'Paying: ',
                                                      size: size.width * 0.04,
                                                      colour: Colors.black54,
                                                    ),
                                                    AppText(
                                                      text: payment.nickName,
                                                      size: size.width * 0.04,
                                                      colour: Colors.black87
                                                          .withOpacity(0.7),
                                                      weight: FontWeight.w400,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.009,
                                                ),
                                                Container(
                                                  height: 1,
                                                  width: size.width * 0.6,
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
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
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.05),
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.008),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.1,
                                                ),
                                                AppText(
                                                  text: 'Exchange rate: ',
                                                  size: size.width * 0.038,
                                                  colour: Colors.black87
                                                      .withOpacity(0.4),
                                                ),
                                                AppText(
                                                  text: getCurrencyAmount(
                                                          context,
                                                          mainAccount.currency,
                                                          1.00) +
                                                      ' is ' +
                                                      getCurrencyAmount(
                                                          context,
                                                          payment.currency,
                                                          rateData.rate),
                                                  size: size.width * 0.041,
                                                  colour: Colors.black87
                                                      .withOpacity(0.7),
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
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.05),
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.008),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.1,
                                                ),
                                                AppText(
                                                  text: 'Fees: ',
                                                  size: size.width * 0.038,
                                                  colour: Colors.black87
                                                      .withOpacity(0.5),
                                                ),
                                                AppText(
                                                  text: "AUD 0.00",
                                                  size: size.width * 0.041,
                                                  colour: Colors.black87
                                                      .withOpacity(0.7),
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
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.05),
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.1,
                                                ),
                                                AppText(
                                                  text: 'Total Fees: ',
                                                  size: size.width * 0.038,
                                                  colour: Colors.black54
                                                      .withOpacity(0.5),
                                                ),
                                                AppText(
                                                  text: "AUD 0.00",
                                                  size: size.width * 0.041,
                                                  colour: Colors.black87
                                                      .withOpacity(0.7),
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
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: size.width,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                        // margin: const EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.black54
                                                  .withOpacity(0.4)),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Final Amount: ",
                                              style: TextStyle(
                                                  fontSize: size.width * 0.038,
                                                  color: Colors.black87
                                                      .withOpacity(0.6)),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.01,
                                            ),
                                            Text(
                                              resController.text,
                                              style: TextStyle(
                                                  fontSize: size.width * 0.043,
                                                  color: AppColours.buttoncolor
                                                      .withOpacity(0.9),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: spinkit,
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext cont) {
                        return AlertDialog(
                          scrollable: true,
                          backgroundColor: const Color(0xFFEBF4F8),
                          actions: [
                               StreamBuilder<bool>(
                                 stream: bs.boolstream,
                                 initialData: false,
                                 builder: (con, snapshot) {
                                   return (snapshot.data!) ? TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          BlocProvider.of<AppCubit>(context).gotoEnvoicePage(mainAccount, payment, finalAmount);
                                        },
                                        child: const Text("Done"),
                                      ) : Container();
                                 }
                               ),
                          ],
                          title: AppLargeText(
                            text: 'Payment Summary',
                            size: 22,
                          ),
                          content: FutureBuilder(
                            future: postTransfer(
                                payment.bankName,
                                payment.identification,
                                finalAmount.toString(),
                                payment.description),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                bs.boolsink.add(true);
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                        text: 'Merchant name: ' +
                                            payment.nickName),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    AppText(
                                      text: 'Amount: ' +
                                          getCurrencyAmount(context,
                                              payment.currency, payment.amount),
                                      colour: Colors.black54,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    AppText(
                                      text: 'Paid :' +
                                          getCurrencyAmount(
                                              context,
                                              mainAccount.currency,
                                              finalAmount),
                                      colour: Colors.black87,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    AppText(
                                      text: 'No fees !',
                                      colour: Colors.black54,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text("Error: " + "${snapshot.error}");
                              } else {
                                return const SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: spinkit,
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: size.width * 0.125,
                    width: size.width,
                    margin: EdgeInsets.all(size.width * 0.05),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColours.buttoncolor,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        const Text(
                          "Pay",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Image(
                          image: const AssetImage("assets/images/arrow.png"),
                          height: size.width * 0.05,
                          width: size.width * 0.05,
                          color: Colors.white,
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Stream<RateData> generateRateStream(String currency) async* {
    Future.delayed(const Duration(minutes: 1)); // 1 request per 60 seconds
    //print('Generating stream..');
    Rate rate = await getRate(currency);
    yield RateData(rate: rate);
  }
}
