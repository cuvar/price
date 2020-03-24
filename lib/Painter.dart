import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  Painter(this.context);
  BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    final size = MediaQuery.of(context).size.width;

    final w = 200;
    final h = 100;
    final x = (size - w) / 2;
    final y = x * 1.5;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.blue;

    canvas.drawRect(Rect.fromPoints(Offset(x, y), Offset(x + w, y + h)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    //return true when smth needs to be repainted
    return false;
  }
}
