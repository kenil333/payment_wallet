import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
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
    return Container(child: BlocBuilder<AppCubit, CubitState>(
      builder: (context, state) {
        if (state is ConfirmPaymentState) {
          TensoAccount mainAccount = state.mainAccount;
          TensoPayment payment = state.tensoPayment;
          return Scaffold(
            body: Container(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ).onTap(() {
                      BlocProvider.of<AppCubit>(context).goToMainPage(0);
                    }).paddingOnly(top: 25, right: 16),
                  ),
                  Container(
                    decoration: boxDecorationRoundedWithShadow(
                      30,
                      backgroundColor: Colors.white.withOpacity(1.0),
                      blurRadius: 10.0,
                      spreadRadius: 4.0,
                      shadowColor: Colors.grey.withAlpha(50),
                    ),
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      children: [
                        AppLargeText(text: 'Payment Confirmation'),
                        AppText(
                            text: 'You have ' +
                                getCurrencyAmount(context, mainAccount.currency,
                                    mainAccount.balance)),
                        AppText(text: 'Paying ' + payment.nickName),
                        AppText(
                            text: 'Amount : ' +
                                getCurrencyAmount(
                                    context, payment.currency, payment.amount)),
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
                                return Container(
                                  child: Column(
                                    children: [
                                      AppText(text: 'Exchange rate :'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AppText(
                                          text: mainAccount.currency +
                                              getCurrencyAmount(context,
                                                  mainAccount.currency, 1.00) +
                                              ' is ' +
                                              getCurrencyAmount(
                                                  context,
                                                  payment.currency,
                                                  rateData.rate)),
                                      AppText(text: 'Fees: AUD 0.00'),
                                      AppText(text: 'Total fees: AUD 0.00 '),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20),
                                              child: AppText(
                                                  text: 'Final Amount ' +
                                                      getCurrency(
                                                          context,
                                                          mainAccount
                                                              .currency)),
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
                              } else {
                                return SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator());
                              }
                            }),
                      ],
                    ),
                  ),
                  Container(
                    width: 150,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet<dynamic>(
                            isScrollControlled: true,
                            isDismissible: false,
                            enableDrag: false,
                            context: context,
                            backgroundColor: Colors.white,
                            barrierColor: Colors.transparent,
                            builder: (BuildContext bc) {
                              return Container(
                                height:
                                MediaQuery.of(context).size.height - 30,
                                color: Colors.grey.withOpacity(0.7),
                                child: FutureBuilder(
                                  future:postTransfer(payment.bankName, payment.identification, finalAmount.toString(), payment.description),
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                                    if(snapshot!.hasData){
                                      return Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                AppLargeText(text: 'Payment Summary'),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    BlocProvider.of<AppCubit>(context).goToCardDetailPage(mainAccount, mainAccount, 0);
                                                  },
                                                  child: AppText(text: 'Done',),
                                                )
                                              ],
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  AppText(text: 'Merchant name: '+payment.nickName),
                                                  SizedBox(height: 20,),
                                                  AppText(text: 'Amount: '+ getCurrencyAmount(context, payment.currency, payment.amount)),
                                                  SizedBox(height: 20,),
                                                  AppText(text: 'Paid :' + getCurrencyAmount(context, mainAccount.currency, finalAmount)),
                                                  SizedBox(height: 20,),
                                                  AppText(text: 'No fees !')
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }else if (snapshot.hasError) {
                                      return Text("Error: " + "${snapshot.error}");
                                    }else{
                                      return Column(
                                        children: [
                                          AppText(text: 'Sending Payment...'),
                                          SizedBox(height: 50,),
                                          SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator()),
                                        ],
                                      );
                                    }
                                  },
                                  /*
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      BlocProvider.of<AppCubit>(context).goToCardDetailPage(mainAccount, mainAccount, 0);
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Icon(Icons.add_circle_outline),
                                          AppText(text: 'Paid!')
                                        ],
                                      ),
                                    ),
                                  ),
                                  */
                                ),
                              );
                            });
                      },
                      child: AppResponsiveButton(
                        textColour: Colors.white,
                        text: 'Pay',
                        colour: AppColours.mainColour,
                        isResponsive: true,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    ));
  }

  Stream<RateData> generateRateStream(String currency) async* {
    Future.delayed(Duration(minutes: 1)); // 1 request per 60 seconds
    //print('Generating stream..');
    Rate rate = await getRate(currency);
    yield RateData(rate: rate);
  }
}
