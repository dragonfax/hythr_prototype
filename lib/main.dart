import 'package:flutter/material.dart';
import 'package:hythr/pages/signin_widget.dart';
import 'constants.dart';
import 'package:hythr/pages/home.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hythr/google_signin.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  MyApp() {
    _ensureLoggedIn();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      theme: new ThemeData.dark(),
      home: new SignInWidget( child: new HomePage() )
    );
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null)
      user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
    }
  }

}
