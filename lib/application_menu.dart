import 'package:flutter/material.dart';
import 'constants.dart';
import 'content/root.dart';


class ApplicationMenu extends StatelessWidget {

  final bool stylistMode = true;
  // final toggleMode = null;

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
          children: <Widget>[
            new DrawerHeader(
                child: new Row(
                    children: <Widget>[
                      new Icon(Icons.mood),
                      new Text(root.currentUser.realName ?? 'None')
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
            /* new ListTile(
              leading: new Icon(Icons.content_cut),
              title: new Text(stylistMode ? 'Stylist ON' : 'Stylist OFF'),
              onTap: () { toggleMode(); }
            ), */
            new AboutListTile(
              icon: new Icon(Icons.info),
              applicationName: appTitle,
              aboutBoxChildren: [
                new Text("Lead Designers: Yael Amyra, Jeff Gimenez"),
                new Divider(),
                new Text("Lead Developer: Jason Stillwell")
              ],
            ),
          ]
      ),
    );
  }

}
