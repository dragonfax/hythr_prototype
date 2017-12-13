
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hythr/content/user.dart';
import 'current_user.dart';

class CurrentUserData extends InheritedWidget {
  final User user;
  final Widget child;

  CurrentUserData({ @required this.user, @required this.child }) : super(child: child);

  static User of(BuildContext context) {
    CurrentUserData cUser = context.inheritFromWidgetOfExactType(CurrentUserData);

    if ( cUser == null ) {
      return null;
    }
    return cUser.user;
  }

  @override
  bool updateShouldNotify(CurrentUserData old) {
    return true;
  }

}

class UserDataChangedWatcher extends StatelessWidget {
  final Widget child;

  UserDataChangedWatcher({this.child});

  Widget build(BuildContext context) {
    User user = CurrentUser.of(context);

    return new StreamBuilder<Event>(
      stream: user.firebaseRef().onValue,
      builder: (context, AsyncSnapshot<Event> asyncEvent) {
        User u;
        if ( asyncEvent?.data?.snapshot != null ) {
          u = new User.fromFirebaseSnapshot(asyncEvent.data.snapshot);
        } else {
          u = user;
        }
        return new CurrentUserData(user: u, child: child);
      }
    );
  }

}
