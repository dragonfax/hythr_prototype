import 'package:flutter/material.dart';


class ApplicationMenu extends StatelessWidget {

  ApplicationMenu(this.userRealName, this.appTitle);

  final String userRealName;
  final String appTitle;

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
          children: <Widget>[
            new DrawerHeader(
                child: new Row(
                    children: <Widget>[
                      new Icon(Icons.mood),
                      new Text(userRealName ?? 'None')
                    ]
                )
            ),
            new ListTile(
                title: new Text('Your Profile')
            ),
            new ListTile(
              title: new Text('Settings'),
            ),
            new ListTile(
              title: new Text('Logout'),
            ),
            new AboutListTile(
                applicationName: appTitle
            ),
          ]
      ),
    );
  }

}
