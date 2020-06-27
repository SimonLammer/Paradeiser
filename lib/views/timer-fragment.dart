import 'package:flutter/material.dart';

class TimerFragment extends StatefulWidget {
  final datetime = DateTime.now().toIso8601String();

  @override
  _TimerFragmentState createState() => _TimerFragmentState();
}

class _TimerFragmentState extends State<TimerFragment> {
  final datetime = DateTime.now().toIso8601String();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Pomodoro timer fragment.\nWidget creation: ${widget.datetime}\nState creation: $datetime\nbuild() call: ${DateTime.now().toIso8601String()}",
          ),
        ],
      ),
    );
  }
}
