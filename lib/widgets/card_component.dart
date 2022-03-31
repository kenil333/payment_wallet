import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';

class CardComponent extends StatelessWidget {
  final TensoAccount? tensoAccount;
  final Size size;
  String profilename;
  final bool islast;
  CardComponent({Key? key, required this.tensoAccount, required this.size, this.profilename = "",required this.islast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('MM/yyyy');
    String formattedDate = dateFormat.format(tensoAccount!.validTill);
    return Container(
      // height: size.width * 0.52,
      width: size.width * 0.85,
      // margin: const EdgeInsets.all(10),
      margin: EdgeInsets.only(left: size.width * 0.05, right: islast ? size.width * 0.05 : 0, bottom: size.width * 0.05),
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: (tensoAccount!.bankName == "NAB")
            ? const Color(0xFFB5E3B8)
            : (tensoAccount!.bankName == "NatWest")
                 ? const Color(0xFFFFCB66)
                 : (tensoAccount!.bankName == "ITAU")
                       ? const Color(0xFFEDB6E4)
                       : const Color(0xFF789AFF),
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     offset: const Offset(0, 8),
          //     color: Colors.green.shade200,
          //     spreadRadius: 8,
          //     blurRadius: 1,
          //   ),
          // ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        margin: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Text(tensoAccount!.bankName,
                    style: secondaryTextStyle(color: Colors.black54, size: 15))),
            Text('Balance', style: secondaryTextStyle(color: Colors.black54, size: 15),),
            SizedBox(height: size.width * 0.03),
            Text( //'${tensoAccount!.currency}' +' '+'${tensoAccount!.balance}',
              getCurrencyAmount(context, tensoAccount!.currency, tensoAccount!.balance),
                style: boldTextStyle(color: Colors.black, size: 20)),
            SizedBox(height: size.width * 0.09),
            Text(profilename, style: primaryTextStyle(color: Colors.black87, size: 15)),
            SizedBox(height: size.width * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tensoAccount!.cardNumber,
                    style: primaryTextStyle(color: Colors.black87, size: 15)),
                Text(formattedDate,
                    style: primaryTextStyle(color: Colors.black87, size: 15)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
