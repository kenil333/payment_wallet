import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/src/extensions/widget_extensions.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/models/tenso_transaction.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/square_button.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';
import 'package:tensopay_wallet_prototype/widgets/transaction_component.dart';

class CardDetails extends StatelessWidget {
  final TensoAccount? mainAccount;
  final TensoAccount? tensoAccount;
  final List<TensoTransaction>? transactions;
  final int index;
  final Size size;

  const CardDetails(
      {Key? key,
      required this.mainAccount,
      required this.tensoAccount,
      required this.transactions,
      required this.index,
      required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Balance details
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              // height: size.width * 0.23,
              width: size.width * 0.9,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              margin: const EdgeInsets.only(bottom: 22.5),
              decoration: BoxDecoration(
                color: AppColours.buttoncolor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: AppColours.buttoncolor,),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(text: 'Available to Spend:', colour: Colors.white, size: 17),
                  const SizedBox(height: 7),
                  //AppText(text: tensoAccount!.currency + ' '+ tensoAccount!.balance.toStringAsFixed(2),colour: Colors.white)
                  AppText(
                      text: getCurrencyAmount(context, tensoAccount!.currency,
                          tensoAccount!.balance),
                      colour: Colors.white,
                    weight: FontWeight.w700,
                    size: 18,
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: size.width * 0.25,
              child: tensoAccount!.bankName == 'NatWest' ||
                    tensoAccount!.bankName == 'ITAU'
                ? Container(
                    margin: EdgeInsets.only(right: size.width * 0.05),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            BlocProvider.of<AppCubit>(context)
                                .goToTopUp(mainAccount!, tensoAccount!, index);
                          },
                          child: Container(
                            height: 45,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColours.buttoncolor, width: 1),
                            ),
                            child: AppText(text: 'Add Funds', colour: AppColours.buttoncolor, size: 15),
                          ),
                        ),
                        const SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<AppCubit>(context).goToScanQr();
                          },
                          child: Container(
                            height: 45,
                            width: size.width * 0.13,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColours.appcolor, width: 1),
                              color: Colors.white,
                            ),
                            child: AppText(text: "Pay", colour: AppColours.appcolor, size: 16,),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        //Recent Activity
        Container(
          margin: EdgeInsets.only(left: size.width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(text: 'Recent activity', size: 17, colour: Colors.black,),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward),
                color: Colors.black,
              )
            ],
          ),
        ),
        //Transactions list
        Container(
          width: double.maxFinite,
          height: size.height * 0.5,
          margin: const EdgeInsets.only(bottom: 10),
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: transactions!.map((transaction) {
                return TransactionComponent(transaction: transaction, size: size,);
              }).toList(),
            ).paddingAll(20),
          ),
        ),
      ],
    );
  }
}
