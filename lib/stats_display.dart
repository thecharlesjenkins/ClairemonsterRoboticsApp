import 'package:flutter/material.dart';
import 'member.dart';

class StatsDisplay extends StatefulWidget {
  final Member member;
  final Color color;

  const StatsDisplay({
    @required this.member,
    @required this.color,
  })  : assert(member != null),
        assert(color != null);

  @override
  _StatsDisplayState createState() => _StatsDisplayState();
}

class _StatsDisplayState extends State<StatsDisplay> {
  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  void signInPressed() {
    if (widget.member.signIn()) {
      showInSnackBar("Signed In!");
    } else {
      showInSnackBar("Already signed in!");
    }
  }

  void signOutPressed() {
    if (widget.member.signOut()) {
      showInSnackBar("Signed Out!");
    } else {
      showInSnackBar("Already signed out!");
    }
  }

  Widget _createButton(BuildContext context, String text, dynamic onPressed) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: MaterialButton(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          onPressed: onPressed,
          child: Text(
            text,
            style:
                Theme.of(context).textTheme.button.apply(fontSizeFactor: 2.0),
          ),
          color: Theme.of(context).primaryColor,
        ));
  }

  Widget _buttonLayout(BuildContext context, Orientation orientation) {
    var signIn = _createButton(context, "Sign In", signInPressed);
    var signOut = _createButton(context, "Sign Out", signOutPressed);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          signIn,
          signOut,
        ],
      ),
    );
  }

  Widget _gridView(BuildContext context, Orientation orientation) {
    List<Widget> texts = [];
    texts.add(_buttonLayout(context, orientation));

    widget.member.toReadable().forEach((key, value) => texts.add(
          Text(
            "$key: $value",
            style: Theme.of(context).textTheme.title,
          ),
        ));

    return GridView.count(
        padding: EdgeInsets.all(18.0),
        shrinkWrap: false,
        crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
        childAspectRatio: 4.0,
        children: texts);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Center(
        child: Scrollbar(
          child: _gridView(context, MediaQuery.of(context).orientation),
        ),
      ),
    );
  }
}
