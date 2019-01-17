import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Time {
  final int hour;
  final int minute;
  final int second;
  final int millisecond;
  final int microsecond;

  Time({
    @required this.hour,
    @required this.minute,
    @required this.second,
    @required this.millisecond,
    @required this.microsecond,
  })  : assert(hour != null),
        assert(minute != null),
        assert(second != null),
        assert(millisecond != null),
        assert(microsecond != null);

  Time.fromDateTime(DateTime dateTime)
      : hour = dateTime.hour,
        minute = dateTime.minute,
        second = dateTime.second,
        millisecond = dateTime.millisecond,
        microsecond = dateTime.microsecond;
//        assert(hour != null),
//        assert(minute != null),
//        assert(second != null),
//        assert(millisecond != null),
//        assert(microsecond != null);

  Time.fromJson(Map jsonMap)
      : hour = jsonMap["hour"],
        minute = jsonMap["minute"],
        second = jsonMap["second"],
        millisecond = jsonMap["millisecond"],
        microsecond = jsonMap["microsecond"];
//        assert(hour != null),
//        assert(minute != null),
//        assert(second != null),
//        assert(millisecond != null),
//        assert(microsecond != null);

  Map<String, int> toJson() => {
        "hour": hour,
        "minute": minute,
        "second": second,
        "millisecond": millisecond,
        "microsecond": microsecond,
      };

  Duration difference(Time other) => Duration(
        hours: other.hour - hour,
        minutes: other.minute - minute,
        seconds: other.second - second,
        milliseconds: other.millisecond - millisecond,
        microseconds: other.microsecond - microsecond,
      );

  @override
  String toString() {
    return "$hour:$minute:$second.$millisecond$microsecond";
  }
}
