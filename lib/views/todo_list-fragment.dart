import 'package:flutter/material.dart';

class TodoListFragment extends StatefulWidget {
  final datetime = DateTime.now().toIso8601String();

  @override
  _TodoListFragmentState createState() => _TodoListFragmentState();
}

class _TodoListFragmentState extends State<TodoListFragment> {
  final datetime = DateTime.now().toIso8601String();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Todo list fragment.\nWidget creation: ${widget.datetime}\nState creation: $datetime\nbuild() call: ${DateTime.now().toIso8601String()}",
          ),
        ],
      ),
    );
  }
}
