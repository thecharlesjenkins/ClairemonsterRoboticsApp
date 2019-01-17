import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'dart:convert';

import 'date.dart';
import 'hours_minutes.dart';
import 'all_members.dart';
import 'time.dart';

final String signOutString = "signOut";
final String signInString = "signIn";

class Member {
  final String name;
  final String title;
  final String email;
  final String id;
  final int gradYear;
  HoursMinutes totalTime = HoursMinutes(seconds: 0, minutes: 0, hours: 0);
  Map<String, dynamic> times = Map<String, Map<String, Time>>();

  Member({
    @required this.name,
    @required this.title,
    @required this.email,
    @required this.id,
    @required this.gradYear,
  })  : assert(name != null),
        assert(title != null),
        assert(email != null),
        assert(id != null),
        assert(gradYear != null);

  /// Creates a [Member] from a JSON object.  The nesting requires the 'name' key
  Member.fromJson(Map jsonMap)
      : name = jsonMap['name'],
        title = jsonMap['title'],
        email = jsonMap['email'],
        id = jsonMap['id'],
        gradYear = int.tryParse(jsonMap['gradYear']),
        totalTime = jsonMap.containsKey('totalTime')
            ? HoursMinutes.fromJson(jsonMap['totalTime'])
            : HoursMinutes(seconds: 0, minutes: 0, hours: 0),
        times = jsonMap.containsKey('times')
            ? json.decode(jsonMap['times'])
            : Map<String, Map<String, Time>>();
//        assert(name != null),
//        assert(title != null),
//        assert(email != null),
//        assert(id != null),
//        assert(gradYear != null),
//        assert(totalTime != null),
//        assert(times != null);

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'email': email,
        'id': id,
        'gradYear': "$gradYear",
        'totalTime': totalTime.toJson(),
        'times': json.encode(times),
      };

  Map<String, String> toReadable() => {
        'Name': name,
        'Title': title,
        'Email': email,
        'Graduation Year': "$gradYear",
        'Hours':
            "${(totalTime.hours+totalTime.minutes/60).toStringAsFixed(2)}", //Get hours to two decimal places
      };

  List<String> toList() => [name, title, id, email, "$gradYear"];

  bool signIn() {
    String today = Date(
      day: DateTime.now().day,
      month: DateTime.now().month,
      year: DateTime.now().year,
    ).toString();

    if (!times.containsKey(today)) {
      times.addAll(
          constructTime(today, Time.fromDateTime(DateTime.now()), null));
      AllMembers().writeMember(member: this);
//      print("signedIn!");
//      print("$times");
      return true;
    }
    return false;
  }

  bool signOut() {
    String today = Date(
      day: DateTime.now().day,
      month: DateTime.now().month,
      year: DateTime.now().year,
    ).toString();

    //Only if they have signed in today AND if they have not already signed out
    if (times.containsKey(today) && times[today][signOutString] == null) {
      //Get the times information for today and append the signOut info
      times[today][signOutString] = Time.fromDateTime(DateTime.now());

      print(times[today][signInString].runtimeType);

      var timeStart = times[today][signInString];

      var timeEnd = times[today][signOutString];

      //Add all of the seconds to the HoursMinutes class which will add them up
      try {
        totalTime += timeStart.difference(timeEnd).inSeconds;
      } catch (e) {
        print('${timeStart.runtimeType}');
        print('${timeEnd.runtimeType}');

        print(e);
      }

      AllMembers().writeMember(member: this);
//      print("signedOut!");
//      print("$times");
      return true;
    }
    return false;
  }

  Map<String, Map<String, Time>> constructTime(
          String date, Time signIn, Time signOut) =>
      {
        "$date": {
          "$signInString": signIn,
          "$signOutString": signOut,
        },
      };

  @override
  String toString() {
    return "$name, $title, $email, $id, $gradYear";
  }
}
