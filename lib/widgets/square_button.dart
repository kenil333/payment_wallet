import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class AppSquareButton extends StatelessWidget {
  final Color colour;
  final Color backgroundColour;
  final Color borderColour;
  String? text;
  IconData? icon;
  bool? isIcon;
  final double size;

  AppSquareButton({Key? key,
  required this.size,
    required this.colour,
    required this.backgroundColour,
    required this.borderColour,
    this.text = 'test',
    this.isIcon = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColour,
          width: 1.0
        ),
        borderRadius: BorderRadius.circular(15),
        color: backgroundColour
      ),
      child: isIcon!? Center(child: Icon(icon, color: colour)):Center(child: AppText( colour: colour, text: text!)),
    );
  }
}

