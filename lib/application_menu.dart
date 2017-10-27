import 'package:flutter/material.dart';


class ApplicationMenu extends StatelessWidget {

  ApplicationMenu(this.userRealName, this.appTitle, this.stylistMode, this.toggleMode);

  final String userRealName;
  final String appTitle;
  final bool stylistMode;
  final toggleMode;

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
            new ListTile(
              title: new Text(stylistMode ? 'Stylist ON' : 'Stylist OFF'),
              onTap: () { toggleMode(); }
            ),
            new AboutListTile(
                applicationName: appTitle
            ),
          ]
      ),
    );
  }

}
