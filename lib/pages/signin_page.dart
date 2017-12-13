import 'package:flutter/material.dart';
import 'package:hythr/signin.dart';
import 'package:hythr/widgets/current_user.dart';


class SignInPage extends StatefulWidget {

  const SignInPage({ this.child });

  final Widget child;

  @override
  SignInState createState() => new SignInState();

}

class SignInState extends State<SignInPage> {

  bool signedIn = false;

  signedInCallback() async {
    await userSignIn.signIn();
    setState(() {
      signedIn = true;
    });
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
    return ! signedIn ? buildSigninPage() : new UserChangedWatcher(child:widget.child);
  }
}