import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CircleTabIndicator extends Decoration {
  final Color colour;
  final double radius;

  const CircleTabIndicator({required this.colour, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    // TODO: implement createBoxPainter
    return CirclePainter(colour: colour, radius: radius);
  }
}

class CirclePainter extends BoxPainter {
  final Color colour;
  final double radius;

  CirclePainter({required this.colour, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint();
    _paint.color = colour;
    _paint.isAntiAlias = true;
    //Need this to place the circle under the text of tab bar. Otherwise, it would be on top of the tab bar text.
    final offSetCircle = Offset(configuration.size!.width / 2 - radius / 2,
        configuration.size!.height - 2* radius);
    canvas.drawCircle(offset + offSetCircle, radius, _paint);
    // TODO: implement paint
  }
}