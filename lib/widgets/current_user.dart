
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hythr/content/user.dart';
import 'package:hythr/signin.dart';

class CurrentUser extends InheritedWidget {
  final User user;
  final Widget child;

  CurrentUser({ @required this.user, @required this.child }) : super(child: child);

  static User of(BuildContext context) {
    CurrentUser cUser = context.inheritFromWidgetOfExactType(CurrentUser);
    return cUser.user;
  }

  @override
  bool updateShouldNotify(CurrentUser old) {
    return old.user != user;
  }

}

class UserChangedWatcher extends StatelessWidget {
  final Widget child;

  UserChangedWatcher({this.child});

  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: userSignIn.onCurrentUserChanged,
      builder: (context, _) {
        User user = userSignIn.currentUser;
        return new CurrentUser(user: user, child: child);
      }
    );
  }

}