import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/registered_events_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        '/registered': (context) => RegisteredEventsScreen(),
      },
    );
  }
}