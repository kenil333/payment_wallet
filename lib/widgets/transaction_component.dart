import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tensopay_wallet_prototype/models/tenso_transaction.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/square_button.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class TransactionComponent extends StatelessWidget {
  final TensoTransaction? transaction;
  final Size size;
  double? height;
  double? width;

  TransactionComponent({Key? key, required this.transaction, this.height = 60, this.width = 350, required this. size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd MMM yyyy');
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(bottom: size.width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFEBF4F8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: AppSquareButton(size: 40, colour: AppColours.textColour2,
                backgroundColour: Colors.white,
                borderColour: AppColours.textColour2,
            isIcon: true,
              icon: transaction!.type == 'CREDIT' || transaction!.type == 'CREDITO'? Icons.arrow_upward_rounded:Icons.arrow_downward_rounded,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(text: transaction!.description, colour: AppColours.mainColour, size: 12,),
                AppText(text: dateFormat.format(transaction!.dateTime),colour: AppColours.mainColour, size: 10,)
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: AppText(text: transaction!.type == 'CREDIT' || transaction!.type == 'CREDITO'? getCurrencyAmount(context,transaction!.currency , double.parse(transaction!.amount)):'-'+ getCurrencyAmount(context,transaction!.currency , double.parse(transaction!.amount)),
              colour: transaction!.type == 'CREDIT'?Colors.blueAccent: Colors.redAccent,),
          )
        ],
      ),
    );
  }
}
