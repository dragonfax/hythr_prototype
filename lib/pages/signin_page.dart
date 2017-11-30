import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hythr/google_signin.dart';
import 'package:firebase_database/firebase_database.dart';


class SignInPage extends StatefulWidget {

  const SignInPage({ this.child });

  final Widget child;

  @override
  SignInState createState() => new SignInState();

}

class SignInState extends State<SignInPage> {

  bool signedIn = false;

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;

    if (user == null) {
      user = await googleSignIn.signInSilently();
    }

    if (user == null) {
      await googleSignIn.signIn();
    }

    // log into firebase
    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials = await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }

    // get the user record, or create it.
    var userDoc = FirebaseDatabase.instance.reference().child('users/' + googleSignIn.currentUser.id);
    var userSnapshot = await userDoc.once();
    if (userSnapshot.value == null ) {
      await userDoc.update({ "real_name": googleSignIn.currentUser.displayName });
    }

    // should be logged in by now.
    setState(() {
      signedIn = true;
    });
  }

  signedInCallback() {
    _ensureLoggedIn();
  }

  Widget buildSigninPage() {
    return new Material( child:
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
  }

  @override
  Widget build(BuildContext context) {
    return ! signedIn ? buildSigninPage() : widget.child;
  }
}