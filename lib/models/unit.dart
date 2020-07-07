import 'dart:async';

import 'unit_plan.dart';

enum UnitState {
  initial,
  running,
  paused,
  canceled,
  overtime,
  finished
}

// TODO: store timestamps of start/pause/...

class Unit {
  final UnitPlan plan;
  final _stateChangeStreamController = StreamController<UnitState>.broadcast();
  final Stopwatch _stopwatch = Stopwatch();

  // ignore: non_constant_identifier_names
  UnitState _state_ = UnitState.initial; // use via getter & setter!
  Timer _timer;

  Unit({
    this.plan
  });

  void dispose() {
    cancel();
    _stateChangeStreamController.close();
  }

  Stream<UnitState> get stateStream => _stateChangeStreamController.stream;
  StreamSink<UnitState> get _stateChangeSink => _stateChangeStreamController.sink;

  Duration get passedDuration => _stopwatch.elapsed;
  Duration get remainingDuration => plan.duration - _stopwatch.elapsed;

  double get progress => passedDuration.inMilliseconds / plan.duration.inMilliseconds;

  UnitState get state => _state_;
  set _state (newState) {
    print("Unit - new state: $newState");
    _state_ = newState;
    _stateChangeSink.add(newState);
  }

  bool get isStartable => state == UnitState.initial || state == UnitState.paused;
  bool start() {
    if (!isStartable) {
      return false;
    }
    _stopwatch.start();
    _timer = Timer(remainingDuration, _timerCallback);
    _state = UnitState.running;
    return true;
  }
  void _timerCallback() {
    if (!_stopwatch.isRunning) {
      return;
    }
    if (remainingDuration > Duration.zero) {
      _timer = Timer(remainingDuration, _timerCallback);
    } else {
      _stopwatch.stop();
      _state = UnitState.overtime;
    }
  }

  bool get isPauseable => state == UnitState.running;
  bool pause() {
    if (!isPauseable) {
      return false;
    }
    _timer?.cancel();
    _stopwatch.stop();
    _state = UnitState.paused;
    return true;
  }

  bool get isCancelable => state == UnitState.initial || state == UnitState.running || state == UnitState.paused;
  bool cancel() {
    if (!isCancelable) {
      return false;
    }
    _timer?.cancel();
    _stopwatch.stop();
    _state = UnitState.canceled;
    return true;
  }

  bool get isStoppable => state == UnitState.overtime;
  bool stop() {
    if (!isStoppable) {
      return false;
    }
    _timer?.cancel();
    _stopwatch.stop();
    _state = UnitState.finished;
    return true;
  }
}
