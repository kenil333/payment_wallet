import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  double size;
  final String text;
  final Color colour;
  FontWeight weight;

  AppText(
      {Key? key, this.size = 16, required this.text, this.colour = Colors.black54, this.weight = FontWeight.normal})
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
