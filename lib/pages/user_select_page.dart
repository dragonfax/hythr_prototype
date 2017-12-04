import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hythr/pages/page.dart';
import 'package:hythr/signin.dart';
import 'package:hythr/content/user.dart';

class UserSelectWidget extends StatelessWidget {

  Widget build(BuildContext context) {
    return new Column(children: [new Flexible(child: new FirebaseAnimatedList(
        query: FirebaseDatabase.instance.reference().child("users"),
        itemBuilder: (_, snapshot, animation, index) {
          return new ListTile(
            title: new Text(snapshot.value['email']),
            onTap: () {
              userSignIn.setCurrentUser(new User.fromFirebaseSnapshot(snapshot));
            }
          );
        }
    ))]);
  }
}

class UserSelectPage {

  static void show(BuildContext context) {
    new Page(
      title: "Select a User",
      child: new UserSelectWidget(),
    ).show(context);

  }
}