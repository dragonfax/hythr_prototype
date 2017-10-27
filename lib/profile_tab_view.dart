import 'package:flutter/material.dart';

class ProfileTabView extends StatelessWidget {

  Widget getTab() {
    return new Tab(
        text: 'Your Profile',
        icon: new Icon(Icons.person)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Center(child: new Text("Nothing yet."));
  }
}
