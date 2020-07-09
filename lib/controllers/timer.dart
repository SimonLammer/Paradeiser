import 'dart:async';

import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/unit.dart';
import '../models/paradeiser_timer.dart';

class TimerController extends ControllerMVC {
  final ParadeiserTimer _paradeiserTimer;

  StreamSubscription _unitStateStreamSubscription;

  TimerController(this._paradeiserTimer) {
    _unitStateStreamSubscription = _paradeiserTimer.unitStateStream.listen((newState) {
      print("TimerController - new state $newState");
    });
  }

  @override
  dispose() { // TODO: ensure this is called eventually
    _unitStateStreamSubscription.cancel();
    print("TC DISPOSED");
    super.dispose();
  }

  Stream<UnitState> get unitStateStream => _paradeiserTimer.unitStateStream;
  Stream<Unit> get unitStream => _paradeiserTimer.unitStream;

  Duration get currentUnitRemainingDuration => _paradeiserTimer.unit.remainingDuration;
  Duration get currentUnitPassedDuration => _paradeiserTimer.unit.passedDuration;
  Duration get currentUnitOvertimeDuration => _paradeiserTimer.unit.overtimeDuration;
  Duration get currentUnitPlannedDuration => _paradeiserTimer.unit.plan.duration;

  Duration get nextUnitPlannedDuration => _paradeiserTimer.nextUnit.plan.duration;

  double get progress => _paradeiserTimer.progress;

  bool get isPauseable => _paradeiserTimer.unit.isPauseable;

  void reset() {
    _paradeiserTimer.reset(plans: _paradeiserTimer.plans);
  }

  void start() {
    if (currentUnitOvertimeDuration > Duration.zero) {
      _paradeiserTimer.moveToNextUnit();
    }
    _paradeiserTimer.unit.start();
  }

  void pause() {
    _paradeiserTimer.unit.pause();
  }

  void skip() {
    _paradeiserTimer.moveToNextUnit();
  }

  void toggle() {
    if (_paradeiserTimer.unit.state == UnitState.running) {
      pause();
    } else {
      start();
    }
  }
}
