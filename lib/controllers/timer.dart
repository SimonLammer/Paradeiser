import 'dart:async';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:tuple/tuple.dart';

import '../models/unit.dart';
import '../models/unit_plan.dart';
import '../models/paradeiser_timer.dart';

class TimerController extends ControllerMVC {
  final ParadeiserTimer paradeiserTimer;

  StreamSubscription _unitStateStreamSubscription;

  TimerController(this.paradeiserTimer) {
    _unitStateStreamSubscription = paradeiserTimer.unitStateStream.listen((newState) {
      print("TimerController - new state $newState");
    });
  }

  @override
  dispose() { // TODO: ensure this is called eventually
    _unitStateStreamSubscription.cancel();
    print("TC DISPOSED");
    super.dispose();
  }

  Stream<UnitState> get unitStateChangeStream => paradeiserTimer.unitStateStream;
  Stream<Unit> get unitStream => paradeiserTimer.unitStream;

  Stream<Tuple3<Duration, Duration, Duration>> periodicUnitDurationStream(Duration period) => Stream.periodic(period, (_) {
    if (period > Duration(milliseconds: 900))
      print("TimerController.periodicUnitDurationStream - $currentUnitDurationTuple @ ${DateTime.now().toIso8601String()}");
    return currentUnitDurationTuple;
  });

  Duration get currentUnitPlannedDuration => paradeiserTimer.unit.plan.duration;
  Duration get currentUnitRemainingDuration => paradeiserTimer.unit.remainingDuration;
  Duration get currentUnitPassedDuration => paradeiserTimer.unit.passedDuration;

  Tuple3<Duration, Duration, Duration> get currentUnitDurationTuple => Tuple3(
    currentUnitRemainingDuration,
    currentUnitPassedDuration,
    currentUnitPlannedDuration,
  );

  double get progress => paradeiserTimer.progress;

  bool get isPauseable => paradeiserTimer.unit.isPauseable;

  void reset() {
    paradeiserTimer.reset(plans: paradeiserTimer.plans);
  }

  void start() {
    paradeiserTimer.unit.start();
  }

  void pause() {
    paradeiserTimer.unit.pause();
  }

  void skip() {
    print("TimerController - skip() ${DateTime.now().toIso8601String()}");
    paradeiserTimer.moveToNextUnit();
  }

  void toggle() {
    if (paradeiserTimer.unit.state == UnitState.running) {
      pause();
    } else {
      start();
    }
  }
}
