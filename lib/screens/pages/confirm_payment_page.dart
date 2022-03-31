import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tensopay_wallet_prototype/data/spinkit/spinkit.dart';
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(child: BlocBuilder<AppCubit, CubitState>(
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
                  // Container(
                  //   padding: const EdgeInsets.all(8),
                  //   margin: const EdgeInsets.all(8),
                  //   decoration: boxDecorationWithRoundedCorners(
                  //     backgroundColor: Colors.transparent,
                  //     borderRadius: BorderRadius.circular(8),
                  //     border: Border.all(color: Colors.white60),
                  //   ),
                  //   child:
                  //       const Icon(Icons.arrow_back, color: Colors.white),
                  // ).onTap(() {
                  //   BlocProvider.of<AppCubit>(context).goToMainPage(0);
                  // }).paddingOnly(top: 25, right: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: size.height * 0.53,
                  width: size.width * 0.9,
                  padding: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xff50B2FA),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    ),
                    margin: const EdgeInsets.all(2),
                    // height: size.height * 0.53,
                    width: size.width * 0.9,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppLargeText(
                            text: 'Payment Confirmation', size: 21, colour: Colors.black87.withOpacity(0.7), weight: FontWeight.w600),
                        const SizedBox(height: 12),
                        AppText(
                            text: 'You have ' +
                                getCurrencyAmount(
                                    context,
                                    mainAccount.currency,
                                    mainAccount.balance),
                            colour: Colors.black,
                            size: 17),
                        const SizedBox(height: 8),
                        AppText(
                            text: 'Paying ' + payment.nickName, size: 15),
                        const SizedBox(height: 8),
                        AppText(
                          text: 'Amount : ' +
                              getCurrencyAmount(context, payment.currency,
                                  payment.amount),
                          size: 15.5,
                          colour: Colors.black87,
                        ),
                        const SizedBox(height: 8),
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
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                        text: 'Exchange rate :',
                                        colour: Colors.black87,
                                        size: 15),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    AppText(
                                      text: mainAccount.currency +
                                          getCurrencyAmount(context,
                                              mainAccount.currency, 1.00) +
                                          ' is ' +
                                          getCurrencyAmount(
                                              context,
                                              payment.currency,
                                              rateData.rate),
                                      size: 14,
                                    ),
                                    AppText(
                                      text: 'Fees: AUD 0.00',
                                      size: 14,
                                    ),
                                    AppText(
                                      text: 'Total fees: AUD 0.00 ',
                                      size: 14,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: 'Final Amount ' +
                                              getCurrency(context,
                                                  mainAccount.currency),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10),
                                            child: TextField(
                                              controller: resController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                ),
                                                hintText: '0.00',
                                                labelStyle: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black54
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator()),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          backgroundColor: const Color(0xFFEBF4F8),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                BlocProvider.of<AppCubit>(context)
                                    .goToCardDetailPage(
                                        mainAccount, mainAccount, 0);
                              },
                              child: const Text("Done"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
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
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                        text: 'Merchant name: ' +
                                            payment.nickName),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    AppText(
                                      text: 'Amount: ' +
                                          getCurrencyAmount(
                                              context,
                                              payment.currency,
                                              payment.amount),
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
                                    // InkWell(
                                    //   onTap: () {
                                    //     Navigator.pop(context);
                                    //     BlocProvider.of<AppCubit>(context)
                                    //         .goToCardDetailPage(
                                    //         mainAccount,
                                    //         mainAccount,
                                    //         0);
                                    //   },
                                    //   child: AppText(
                                    //     text: 'Done',
                                    //     colour: Colors.blue,
                                    //   ),
                                    // ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    "Error: " + "${snapshot.error}");
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
                        SizedBox(width: size.width * 0.05,),
                        Image(
                          image: const AssetImage(
                              "assets/images/arrow.png"),
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
    ));
  }

  Stream<RateData> generateRateStream(String currency) async* {
    Future.delayed(const Duration(minutes: 1)); // 1 request per 60 seconds
    //print('Generating stream..');
    Rate rate = await getRate(currency);
    yield RateData(rate: rate);
  }
}
