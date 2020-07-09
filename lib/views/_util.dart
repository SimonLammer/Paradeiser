import 'package:flutter/material.dart';

Widget border(Widget child, Color color, double width) {
  return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
      ),
      child: child
  );
}

// ignore: non_constant_identifier_names
String formatDuration_mm_ss(Duration duration) => "${duration.inMinutes}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}";
