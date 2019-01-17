import 'package:flutter/material.dart';

import 'members_view.dart';
import 'navigation_route.dart';
import 'splashscreen.dart';


void main() => runApp(new MyApp());
List<BottomNavigationBarItem> items = [
  new BottomNavigationBarItem(
    icon: const Icon(Icons.access_alarm),
    title: Text('Alarm'),
    backgroundColor: Colors.deepPurple,
  ),
  new BottomNavigationBarItem(
    icon: const Icon(Icons.add),
    title: Text('Add'),
    backgroundColor: Colors.deepOrange,
  ),
];

class MyApp extends StatelessWidget {
  static GlobalKey backdropKey = GlobalKey(debugLabel: "backdrop");
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clairemonster',
      routes: <String, WidgetBuilder>{
        '/MembersView': (BuildContext context) => new MembersView(backdropKey: backdropKey,),
      },
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.grey[600],
              decorationColor: Colors.grey[600],
            ),
        // This colors the [InputOutlineBorder] when it is selected
        primaryColor: Colors.blue,
        accentColor: Colors.deepOrange,
      ),
      home:  SplashScreen(),
    );
  }
}
