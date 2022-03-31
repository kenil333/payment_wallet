import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLargeText extends StatelessWidget {
  double size;
  final String text;
  final Color colour;
  FontWeight weight;


  AppLargeText(
      {Key? key, this.size = 30, required this.text, this.colour = Colors.black87, this.weight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: colour,
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }
}
