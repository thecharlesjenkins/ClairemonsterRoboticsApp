import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Date {
  final int day;
  final int month;
  final int year;

  Date({
    @required this.day,
    @required this.month,
    @required this.year,
  })  : assert(day != null),
        assert(month != null),
        assert(year != null);



  @override
  String toString() {
    return "$month/$day/$year";
  }

}