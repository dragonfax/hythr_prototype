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
              leading: new Icon(Icons.settings),
              title: new Text('Settings'),
            ),
            new ListTile(
              leading: new Icon(Icons.time_to_leave),
              title: new Text('Logout'),
            ),
            new ListTile(
              leading: new Icon(Icons.content_cut),
              title: new Text(stylistMode ? 'Stylist ON' : 'Stylist OFF'),
              onTap: () { toggleMode(); }
            ),
            new AboutListTile(
              icon: new Icon(Icons.info),
              applicationName: appTitle
            ),
          ]
      ),
    );
  }

}
