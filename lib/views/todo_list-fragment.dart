import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

import 'package:paradeiser/models/task.dart';
import 'package:tuple/tuple.dart';

class TodoListFragment extends StatefulWidget {
  final datetime = DateTime.now().toIso8601String();

  @override
  _TodoListFragmentState createState() => _TodoListFragmentState();
}

class TaskWrapper {
  final Task task;
  final UniqueKey key = UniqueKey();
  Widget widget;

  TaskWrapper(final this.task);
}

class _TodoListFragmentState extends State<TodoListFragment> {
  final datetime = DateTime.now().toIso8601String();

  static const maxIndex = 17;

  final List<TaskWrapper> tasks = List.generate(
      maxIndex + 1, (i) => TaskWrapper(Task(String.fromCharCode(i + 65))));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Todo list fragment.\nWidget creation: ${widget.datetime}\nState creation: $datetime\nbuild() call: ${DateTime.now().toIso8601String()}",
          ),
          Expanded(
              child: ReorderableList(
            onReorder: (Key n, Key o) {
              int oldIndex = tasks.indexWhere((t) => t.key == o);
              int newIndex = tasks.indexWhere((t) => t.key == n);
              print("onReorder($n, $o) ; $newIndex <-> $oldIndex");
              setState(() {
                dynamic tmp = tasks[oldIndex];
                tasks[oldIndex] = tasks[newIndex];
                tasks[newIndex] = tmp;
                print("setState $newIndex <-> $oldIndex");
              });
              return true;
            },
            onReorderDone: (Key key) {
//                print("onReorderDone($key)");
            },
            child: CustomScrollView(slivers: [
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                _reorderableItemBuilder,
                childCount: maxIndex + 1,
              ))
            ]),
          ))
        ],
      ),
    );
  }

  Widget _reorderableItemBuilder(BuildContext context, int index) {
    return ReorderableItem(
      key: tasks[index].key,
      childBuilder: (BuildContext context, ReorderableItemState state) {
        BoxDecoration decoration;

        if (state == ReorderableItemState.dragProxy ||
            state == ReorderableItemState.dragProxyFinished) {
          decoration = BoxDecoration(color: Color(0xD0FFFFFF));
        } else {
          bool placeholder = state == ReorderableItemState.placeholder;
          decoration = BoxDecoration(
            border: Border(
              top: index == 0 && !placeholder
                  ? Divider.createBorderSide(context)
                  : BorderSide.none,
              bottom: index == maxIndex && placeholder
                  ? BorderSide.none
                  : Divider.createBorderSide(context),
            ),
            color: placeholder ? null : Colors.white,
          );
        }

        Widget dragHandle = ReorderableListener(
            child: Container(
                padding: EdgeInsets.only(right: 18.0, left: 18.0),
                color: Color(0x08000000),
                child: Center(
                  child: Icon(Icons.reorder, color: Color(0xFF888888)),
                )));

        Widget content = Container(
          decoration: decoration,
          child: SafeArea(
              top: false,
              bottom: false,
              child: Opacity(
                  opacity: state == ReorderableItemState.placeholder ? 0 : 1,
                  child: IntrinsicHeight(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 14.0),
                        child: tasks[index].widget ??=
                            _taskWidget(tasks[index].task),
                      )),
                      dragHandle,
                    ],
                  )))),
        );

        return content;
      },
    );
  }

  Widget _taskWidget(Task task) => Row(
    children: [
      StatefulBuilder(
        builder: (context, setState) => Checkbox(
          value: task.complete,
          onChanged: (v) => setState(() {
            task.complete = v;
          }),
        ),
      ),
      Expanded(
        child: TextField(
          controller: TextEditingController.fromValue(
              TextEditingValue(text: task.name)),
          onChanged: ((v) {
            task.name = v;
          }),
      ))
    ],
  );
}
