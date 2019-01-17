import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'member.dart';

/// A [Category] keeps track of a list of [Unit]s.
class Category {
  final String name;
  final ColorSwatch color;
  final IconData icon;
  final SearchDelegate searchDelegate;
  final Member member;

  /// Information about a [Category].
  const Category({
    @required this.name,
    @required this.color,
    @required this.icon,
    @required this.member,
    this.searchDelegate,
  })  : assert(name != null),
        assert(color != null),
        assert(icon != null),
        assert(member != null);
}
