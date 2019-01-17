import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class HoursMinutes {
  int seconds;
  int minutes;
  int hours;

  HoursMinutes({
    @required this.seconds,
    @required this.minutes,
    @required this.hours,
  })  : assert(seconds != null),
        assert(minutes != null),
        assert(hours != null);

  HoursMinutes operator +(int seconds) {
    int totalSeconds = seconds + this.seconds;
    this.seconds = totalSeconds % 60;
    int totalMinutes = totalSeconds ~/ 60;
    this.minutes = totalMinutes % 60;
    int totalHours = totalMinutes ~/ 60;
    this.hours = totalHours;

    return HoursMinutes(seconds: this.seconds, minutes: this.minutes, hours: this.hours);
  }

  @override
  String toString() {
    return "$hours hours: $minutes minutes: $seconds seconds";
  }

  HoursMinutes.fromJson(Map jsonMap)
    : hours = jsonMap["hours"].runtimeType == int ? jsonMap["hours"] : int.parse(jsonMap["hours"]),
      minutes = jsonMap["minutes"].runtimeType == int ? jsonMap["minutes"] : int.parse(jsonMap["minutes"]),
      seconds = jsonMap["seconds"].runtimeType == int ? jsonMap["seconds"] : int.parse(jsonMap["seconds"]);
//      assert(hours != null),
//      assert(minutes != null),
//      assert(seconds != null);

  Map<String, int> toJson() => {
    "hours": hours,
    "minutes": minutes,
    "seconds": seconds
  };

}
