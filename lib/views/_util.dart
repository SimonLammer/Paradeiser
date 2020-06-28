import 'package:flutter/material.dart';

Widget border(Widget child, Color color, double width) {
  return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
      ),
      child: child
  );
}
