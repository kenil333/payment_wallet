import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';

class CardComponent extends StatelessWidget {
  final TensoAccount? tensoAccount;
  double? width;

  CardComponent({Key? key, required this.tensoAccount, this.width = 300})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('MM/yyyy');
    String formattedDate = dateFormat.format(tensoAccount!.validTill);
    return Container(
      width: width,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 30, top: 8),
      decoration: boxDecorationRoundedWithShadow(
        30,
        backgroundColor: Color(tensoAccount!.colour).withOpacity(1.0),
        blurRadius: 10.0,
        spreadRadius: 4.0,
        shadowColor: Color(tensoAccount!.colour).withAlpha(50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Text('${tensoAccount!.bankName}',
                  style: secondaryTextStyle(color: Colors.white60))),
          Text('Balance', style: secondaryTextStyle(color: Colors.white60)),
          8.height,
          Text( //'${tensoAccount!.currency}' +' '+'${tensoAccount!.balance}',
            getCurrencyAmount(context, tensoAccount!.currency, tensoAccount!.balance),
              style: boldTextStyle(color: Colors.white, size: 18)),
          30.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${tensoAccount!.cardNumber}',
                  style: primaryTextStyle(color: Colors.white70)),
              Text('${formattedDate}',
                  style: primaryTextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}
