import 'dart:async';

import 'unit.dart';
import 'unit_plan.dart';

class ParadeiserTimer {
  static ParadeiserTimer _instance;
  factory ParadeiserTimer.singleton() => _instance ?? (_instance = ParadeiserTimer(plans: UnitPlan.debugPlanSequence));

  final _unitStreamController = StreamController<Unit>.broadcast();
  final _currentStateStreamController = StreamController<UnitState>.broadcast();

  Iterable<UnitPlan> _plans;
  Iterator<UnitPlan> _planIterator;
  Unit unit;
  Unit _nextUnit;

  StreamSubscription _unitStateStreamSubscription;

  ParadeiserTimer({
    Iterable<UnitPlan> plans,
  }) {
    reset(plans: plans);
  }

  Stream<Unit> get unitStream => _unitStreamController.stream;
  StreamSink<Unit> get _unitSink => _unitStreamController.sink;

  Stream<UnitState> get unitStateStream => _currentStateStreamController.stream;
  StreamSink<UnitState> get _currentUnitStateSink => _currentStateStreamController.sink;

  Iterable<UnitPlan> get plans => _plans;

  Unit get nextUnit => _nextUnit;

  double get progress => unit == null ? 0 : unit.progress;

  void dispose() {
    unit?.dispose();
    _nextUnit?.dispose();
    _unitStreamController.close();
    _currentStateStreamController.close();
  }

  void reset({
    Iterable<UnitPlan> plans,
  }) {
    if (plans == null) {
      plans = this.plans;
    }
    assert(plans.length > 0);
    _plans = plans;
    _planIterator = _plans.iterator;

    // initialize `unit` & `_nextUnit`
    moveToNextUnit();
    moveToNextUnit();
  }

  void moveToNextUnit() {
    if (!_planIterator.moveNext()) {
      _planIterator = _plans.iterator;
      _planIterator.moveNext();
    }
    _unitStateStreamSubscription?.cancel(); // suppresses `unit`'s `canceled` state when `.dispose()`d
    unit?.dispose();
    unit = _nextUnit;
    _nextUnit = Unit(plan: _planIterator.current);
    _unitSink.add(unit);
    if (unit != null) { //  && !_currentStateStreamController.isClosed
      _unitStateStreamSubscription = unit.stateStream.listen((newState) {
        _currentUnitStateSink.add(newState);
      });
      _currentUnitStateSink.add(unit.state);
    }
  }
}