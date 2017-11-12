import 'package:flutter/material.dart';

import 'package:hythr/pages/signin_widget.dart';
import 'constants.dart';
import 'package:hythr/pages/home.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      theme: new ThemeData.dark(),
      home: const SignInWidget( child: const HomePage()),
    );
  }

}
