import 'package:flutter/material.dart';

import 'members_view.dart';
import 'sign_in.dart';



class NavigationRoute extends StatefulWidget {
  const NavigationRoute();

  @override
  _NavigationRouteState createState() => _NavigationRouteState();
}

class _NavigationRouteState extends State<NavigationRoute> {
  int _currentIndex = 0;
  static GlobalKey key = GlobalKey(debugLabel: "backdrop");
  static Widget _membersView = MembersView(backdropKey: key);
  static Widget _signIn = SignIn();

  List<BottomNavigationBarItem> _navigationBarItems = [
    new BottomNavigationBarItem(
      icon: Image.asset('assets/icons/qrcode.png', width: 30.0),
      title: Text('Sign In'),
      backgroundColor: Colors.blue,
    ),
    new BottomNavigationBarItem(
      icon: Icon(Icons.people),
      title: Text('Members'),
      backgroundColor: Colors.deepOrange,
    ),
  ];

  List<Widget> _children = [
    _signIn,
   _membersView,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navigationBarItems,
        onTap: onTabTapped,
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
      ),
    );
  }

  void onTabTapped(index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
