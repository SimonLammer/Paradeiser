import 'package:flutter/material.dart';

import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '_util.dart';
import 'timers/circular1.dart';

class TimerFragment extends StatefulWidget {
  @override
  _TimerFragmentState createState() => _TimerFragmentState();
}

class _TimerFragmentState extends State<TimerFragment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SearchableDropdown.single(
            items: [
              "Item 1",
              "Item 2",
              "Item 3",
              "Item 4",
              "Object 1",
              "Object 2",
              "Object 3",
              "Object 4",
            ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (value) {
              setState(() {
                print("SD onChanged to $value");
              });
            },
            hint: "Working",
            dialogBox: true,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                child: CircularTimer1(
                )
              )
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(MdiIcons.stopCircleOutline),
                iconSize: 50,
                tooltip: "Stop timer",
                onPressed: () {
                  print("stop");
                },
              ),
              IconButton(
                icon: Icon(MdiIcons.playCircleOutline),
                iconSize: 50,
                tooltip: "Start timer",
                onPressed: () {
                  print("start");
                },
              ),
              IconButton(
                icon: Icon(MdiIcons.skipNextCircleOutline),
                iconSize: 50,
                tooltip: "Skip timer",
                onPressed: () {
                  print("skip");
                },
              ),
            ],
          )
        ],
      )
    );
  }
}
