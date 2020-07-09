enum UnitType {
  work,
  pause, // for breaks
}

class UnitPlan {
  static const basicPlanSequence = [
    UnitPlan(UnitType.work, Duration(minutes: 25)),
    UnitPlan(UnitType.pause, Duration(minutes: 5)),
    UnitPlan(UnitType.work, Duration(minutes: 25)),
    UnitPlan(UnitType.pause, Duration(minutes: 5)),
    UnitPlan(UnitType.work, Duration(minutes: 25)),
    UnitPlan(UnitType.pause, Duration(minutes: 5)),
    UnitPlan(UnitType.work, Duration(minutes: 25)),
    UnitPlan(UnitType.pause, Duration(minutes: 20)),
  ];
  static const debugPlanSequence = [
    UnitPlan(UnitType.work, Duration(milliseconds: 1500)),
    UnitPlan(UnitType.work, Duration(seconds: 15)),
    UnitPlan(UnitType.work, Duration(minutes: 25)),
    UnitPlan(UnitType.pause, Duration(milliseconds: 1500)),
    UnitPlan(UnitType.pause, Duration(seconds: 15)),
    UnitPlan(UnitType.pause, Duration(minutes: 25)),
  ];

  final UnitType type;
  final Duration duration;

  const UnitPlan(this.type, this.duration);
}
