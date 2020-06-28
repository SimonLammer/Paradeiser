import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../_util.dart';

class CircularTimer1 extends StatefulWidget {
  final double circleThickness;
  final double textPaddingFactor;

  CircularTimer1({
    this.textPaddingFactor = 0.8,
    this.circleThickness = 70,
  }) : super();

  @override
  _CircularTimer1State createState() => _CircularTimer1State();
}

class _CircularTimer1State extends State<CircularTimer1> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: CircularTimer1Painter(
            circleThickness: widget.circleThickness
          )
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            var diameter = min(constraints.biggest.width, constraints.biggest.height);
            var padding = ((diameter + widget.circleThickness) - (diameter - widget.circleThickness) / sqrt(2)) / 2; // pad to constrain text to square inscribed in circle
            padding *= widget.textPaddingFactor; // adjust padding
            return Padding(
              padding: EdgeInsets.all(padding),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text("13:59")
              ),
            );
          }
        )
      ],
    );
  }
}

class CircularTimer1Painter extends CustomPainter {
  final double circleThickness;
  final Color backgroundColor;
  final Color foregroundColor;

  CircularTimer1Painter({
    this.circleThickness,
    this.foregroundColor = Colors.grey,
    this.backgroundColor = Colors.black87,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final sidelength = min(size.width, size.height);
    final square = Rect.fromCenter(
      center: size.center(Offset(0, 0)),
      width: sidelength,
      height: sidelength,
    );

    var paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = circleThickness
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
    ;

    canvas.drawCircle(square.center, sidelength / 2 - circleThickness / 2, paint);

    paint
      ..color = foregroundColor
      ..strokeCap = StrokeCap.round
    ;
    canvas.drawPath(
      Path()
        ..arcTo(square.deflate(circleThickness / 2), -pi/2, pi, true),
      paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
