import 'package:flutter/material.dart';

import 'signin_widget.dart';
import 'package:map_view/map_view.dart';
import 'constants.dart';
import 'home.dart';

void main() {
  MapView.setApiKey('AIzaSyD3dwHECky9YbAwgGik_bU_VjXipsSpgr8');
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      theme: new ThemeData.dark(),
      home: new SignInWidget( child: new HomePage()),
    );
  }

}
