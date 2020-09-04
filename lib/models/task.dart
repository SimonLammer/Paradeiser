import 'dart:async';

import 'unit.dart';

class Task {
  String name;
  bool complete = false; // can be archived from open tasks
  List<Unit> units;
  String rank; // https://softwareengineering.stackexchange.com/a/369754

  Task(this.name);

  // sort archived tasks by completion timestamp (in UI)
}
