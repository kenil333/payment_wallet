import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

import '../../cubit/app_cubit_states.dart';
import '../../cubit/app_cubits.dart';
import '../../data/spinkit/spinkit.dart';
import '../../models/tenso_bank_account.dart';
import '../../models/tenso_payment_data.dart';
import '../../utils/api_helper.dart';
import '../../utils/tenso_colours.dart';

class Envoice extends StatefulWidget {
  const Envoice({Key? key}) : super(key: key);

  @override
  State<Envoice> createState() => _EnvoiceState();
}

class _EnvoiceState extends State<Envoice> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<AppCubit, CubitState>(
      builder: (context, state) {
        if (state is EnvoiceState) {
          TensoAccount mainAccount = state.mainAccount;
          TensoPayment payment = state.tensoPayment;
          double finalAmount = state.finalamount;
          return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 15,),
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
                    height: size.height * 0.23,
                    width: size.width * 0.8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffE7F953),
                    ),
                    child: Text("Thank You!\nYour purchase is\nConfirmed.",style: TextStyle(fontSize: size.width * 0.06, color: Colors.black, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AppCubit>(context).goToMainPage(0);
                    },
                    child: Container(
                      height: size.height * 0.08,
                      width: size.width * 0.65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColours.buttoncolor,
                      ),
                      alignment: Alignment.center,
                      child: Text("Done", style: TextStyle(fontSize: size.width * 0.05, color: Colors.white, fontWeight: FontWeight.w500),),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                    future: postTransfer(
                        payment.bankName,
                        payment.identification,
                        finalAmount.toString(),
                        payment.description),
                    builder: (BuildContext context,
                        AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            SizedBox(width: size.width * 0.1,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppText(
                                    text: 'Merchant name:'),
                                const SizedBox(
                                  height: 8,
                                ),
                                AppText(
                                  text: 'Amount:',
                                  colour: Colors.black54,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                AppText(
                                  text: 'Paid:',
                                  colour: Colors.black87,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                AppText(
                                  text: 'Fees:',
                                  colour: Colors.black54,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                            const SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                    text: payment.nickName),
                                const SizedBox(
                                  height: 8,
                                ),
                                AppText(
                                  text: getCurrencyAmount(context,
                                          payment.currency, payment.amount),
                                  colour: Colors.black54,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                AppText(
                                  text: getCurrencyAmount(
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
                  Expanded(child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Need help? Visit our ",),
                      Text("Help Center",style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  SizedBox(height: size.height * 0.05,),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}