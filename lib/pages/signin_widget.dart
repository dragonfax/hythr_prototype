import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInWidget extends StatefulWidget {

  const SignInWidget({ this.child });

  final Widget child;

  @override
  SignInState createState() => new SignInState(child: child);

}

class SignInState extends State<SignInWidget> {

  SignInState({this.child});

  bool signedIn = false;
  final Widget child;

  signedInCallback() {
    setState(() {
      signedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget signInPage = new Material( child:
      new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Column(
          children: [
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 150.0),
              child: new Image.asset("assets/images/logo.png", width: 300.0)
            ),
            new Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: new FlatButton(
                onPressed: signedInCallback,
                child: const Text("Sign in with Google"),
                color: Colors.blue,
                textColor: Colors.white,
              )
            ),
          ]
        )
      )
    );

    return ! signedIn ? signInPage : child;
  }
}