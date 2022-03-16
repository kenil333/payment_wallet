import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  double size;
  final String text;
  final Color colour;

  AppText(
      {Key? key, this.size = 16, required this.text, this.colour = Colors.black54})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: colour,
          fontSize: size,
      ),
    );
  }
}
