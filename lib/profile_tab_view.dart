import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'content/user.dart';
import 'content/tag.dart';
import 'profile_widget.dart';

class ProfileTabView extends StatelessWidget {
  final User user;
  final List<Tag> skills;
  final List<Tag> interests;

  ProfileTabView(this.user, this.skills, this.interests);

  Widget getTab() {
    return new Tab(text: 'Your Profile', icon: new Icon(Icons.person));
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return new Center(child: new Text("Nothing yet."));
    } else {
      return new ProfileWidget(user, true, skills, interests);
    }
  }


}
