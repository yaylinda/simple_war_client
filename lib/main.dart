import 'package:flutter/material.dart';
import 'package:simple_war_client/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Simple War',
      theme: new ThemeData(primarySwatch: Colors.green),
      routes: routes,
    );
  }
}
