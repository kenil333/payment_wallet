import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class AppResponsiveButton extends StatelessWidget {
  bool? isResponsive;
  double? width;
  final String text;
  final Color colour;
  final Color textColour;

  AppResponsiveButton(
      {Key? key, this.width =120, this.isResponsive = false, required this.text, required this.colour, required this.textColour})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: isResponsive!?double.maxFinite:width,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colour),
        child: Row(
          mainAxisAlignment: isResponsive!?MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
          children: [
            isResponsive!?Container(margin: const EdgeInsets.only(left:20),child: AppText(text: text, colour: Colors.white,)):Container(),
            Container(margin: const EdgeInsets.only(right: 15),child: Image.asset('assets/images/arrow.png', height: 22,width: 22,color: Colors.white,)),
          ],
        ),
      ),
    );
  }
}
