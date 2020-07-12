import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class TodoListFragment extends StatefulWidget {
  final datetime = DateTime.now().toIso8601String();

  @override
  _TodoListFragmentState createState() => _TodoListFragmentState();
}

class _TodoListFragmentState extends State<TodoListFragment> {
  final datetime = DateTime.now().toIso8601String();

  static const maxIndex = 11;
  final alphabetList = List.generate(maxIndex + 1, (i) => String.fromCharCode(i + 65));
  final keys = List.generate(maxIndex + 1, (i) => UniqueKey());

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
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                print("onReorder($oldIndex, $newIndex)");
              },
              scrollDirection: Axis.vertical,
              children: List.generate(alphabetList.length, (index) {
                return ListTile(
                  key: UniqueKey(),
                  title: Text(alphabetList[index]),
                );
                },
              ),
            )
          ),
          Expanded(
            child: ReorderableList(
              onReorder: (Key n, Key o) {
                print("onReorder($n, $o)");
                return true;
              },
              onReorderDone: (Key key) {
                print("onReorderDone($key)");
              },
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return ReorderableItem(
                            key: keys[index],
                            childBuilder: (BuildContext context, ReorderableItemState state) {
                              BoxDecoration decoration;

                              if (state == ReorderableItemState.dragProxy || state == ReorderableItemState.dragProxyFinished) {
                                decoration = BoxDecoration(color: Color(0xD0FFFFFF));
                              } else {
                                bool placeholder = state == ReorderableItemState.placeholder;
                                decoration = BoxDecoration(
                                  border: Border(
                                    top: index == 0 && !placeholder ?
                                        Divider.createBorderSide(context)
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
                                  )
                                )
                              );

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
                                                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                                                child: Text(alphabetList[index], style: Theme.of(context).textTheme.subtitle1,),
                                              )
                                            ),
                                            dragHandle,
                                          ],
                                        )
                                      )
                                    )
                                  ),
                              );

                              return content;
                            },
                          );
                        },childCount: maxIndex + 1,
                    )
                  )
                ]
              ),
            )
          )
        ],
      ),
    );
  }
}
