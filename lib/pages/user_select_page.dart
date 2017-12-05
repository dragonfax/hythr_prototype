import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hythr/pages/page.dart';
import 'package:hythr/signin.dart';
import 'package:hythr/content/user.dart';
import 'input_dialog.dart';

class UserSelectWidget extends StatelessWidget {

  Widget build(BuildContext context) {
    return new Column(children: [
      new FlatButton(
          child: const Text("Create New User"),
          onPressed: () async {

            String email = await new InputDialog(
              title: "Enter New User Email",
              labelText: "Email",
              actionLabel: "Create New User"
            ).show(context);

            if ( email != null ) {
              await userSignIn.createNewUser(email);
            }
          }
      ),
      new Expanded(
          child: new FirebaseAnimatedList(
            query: FirebaseDatabase.instance.reference().child("users"),
            itemBuilder: (_, snapshot, animation, index) {
              return new ListTile(
                title: new Text(snapshot.value['email']),
                onTap: () {
                  userSignIn.setCurrentUser(new User.fromFirebaseSnapshot(snapshot));
                  Navigator.of(context).pop();
                }
              );
            }
        )
      )
    ]);
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