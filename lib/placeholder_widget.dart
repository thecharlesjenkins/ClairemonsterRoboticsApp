import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget{
  final String string;
  final ColorSwatch color;

  PlaceholderWidget(this.string, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Center(
        child: Text(string, textAlign: TextAlign.center,),
      )
    );
  }

}