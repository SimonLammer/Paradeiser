import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

//import '_util.dart';
import '../controllers/timer.dart';
import '../models/paradeiser_timer.dart';
import 'timers/circular1.dart';

class TimerFragment extends StatefulWidget {
  @override
  _TimerFragmentState createState() => _TimerFragmentState();
}

class _TimerFragmentState extends StateMVC<TimerFragment> {
  TimerController timerController;

  @override
  void initState() {
    super.initState();
    timerController = TimerController(ParadeiserTimer.singleton());
  }

  @override
  void dispose() {
    print("TimerFragment.dispose");
    timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<TimerController>(
      create: (context) => timerController,
      child: Center(
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
                  tooltip: "Reset timer",
                  onPressed: () {
                    timerController.reset();
                  },
                ),
                IconButton(
                  icon: StreamBuilder(
                    stream: timerController.unitStream,
                    builder: (_, __) => StreamBuilder(
                      stream: timerController.unitStateChangeStream,
                      builder: (___, ____) => timerController.isPauseable ? Icon(MdiIcons.pauseCircleOutline) : Icon(MdiIcons.playCircleOutline),
                    ),
                  ),
                  iconSize: 50,
                  tooltip: "Start timer",
                  onPressed: () {
                    timerController.toggle();
                  },
                ),
                IconButton(
                  icon: Icon(MdiIcons.skipNextCircleOutline),
                  iconSize: 50,
                  tooltip: "Skip remaining unit",
                  onPressed: () {
                    timerController.skip();
                  },
                ),
              ],
            )
          ],
        )
      )
    );
  }
}
