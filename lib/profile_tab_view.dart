import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'content.dart';
import 'profile_widget.dart';
import 'set_state_callback.dart';

class ProfileTabView extends StatelessWidget {
  final User user;
  final SetStateCallback userChangingCallback;

  ProfileTabView(this.user, this.userChangingCallback);

  Widget getTab() {
    return new Tab(text: 'Your Profile', icon: new Icon(Icons.person));
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return new Center(child: new Text("Nothing yet."));
    } else {
      return new ProfileWidget(user, userChangingCallback);
    }
  }


}
