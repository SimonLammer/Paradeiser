import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../_util.dart';
import '../../controllers/timer.dart';
import '../widgets/stream_listenable_adapter.dart';

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
        Consumer<TimerController>(
          builder: (context, timerController, _) =>
            StreamListenableAdapter(
              stream: timerController.periodicUnitDurationStream(Duration(milliseconds: 100)),
              initialData: timerController.currentUnitDurationTuple,
              builder: (context, notifier) =>
                CustomPaint(
                  painter: CircularTimer1Painter(
                    timerController: timerController,
                    circleThickness: widget.circleThickness,
                    repaint: notifier,
                  ),
                ),
            ),
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
                child: Consumer<TimerController>(
                  builder: (context, timerController, _) =>
                    StreamBuilder(
                      stream: timerController.unitStream,
                      builder: (__, ___) => StreamBuilder(
                        initialData: timerController.currentUnitDurationTuple,
                        stream: timerController.periodicUnitDurationStream(Duration(seconds: 1)),
                        builder: (context, AsyncSnapshot<Tuple3<Duration, Duration, Duration>> snapshot) {
                          // TODO: fix initial snapshot data - bug shown in 021c9ae (bug-stream_builder-initial_snapshot_data)
//                          print("CTS - building timer text at ${DateTime.now().toIso8601String()}; tuple: ${timerController.currentUnitDurationTuple}; data: ${snapshot.data}");
                          return Text(formatDuration_mm_ss(snapshot.data.item1));
                        }
                      ),
                    ),
                ),
              ),
            );
          }
        )
      ],
    );
  }
}

class CircularTimer1Painter extends CustomPainter {
  final TimerController timerController;
  final double circleThickness;
  final Color backgroundColor;
  final Color foregroundColor;
  final Listenable repaint;

  CircularTimer1Painter({
    @required this.timerController,
    this.circleThickness,
    this.foregroundColor = Colors.grey,
    this.backgroundColor = Colors.black87,
    this.repaint,
  }) : super(repaint: repaint);

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
        ..arcTo(square.deflate(circleThickness / 2), -pi/2, min(timerController.progress, 1.0) * pi * 2.0, true), // TODO: fix arc disappearance on 2*pi length
      paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
