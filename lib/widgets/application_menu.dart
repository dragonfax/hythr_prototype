import 'package:flutter/material.dart';
import '../constants.dart';
import '../content/content.dart';


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
                      const Icon(Icons.mood),
                      new Text(root.currentUser.realName ?? 'None')
                    ]
                )
            ),
            const ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
            const ListTile(
              leading: const Icon(Icons.time_to_leave),
              title: const Text('Logout'),
            ),
            const AboutListTile(
              icon: const Icon(Icons.info),
              applicationName: appTitle,
              aboutBoxChildren: const [
                const Text("Lead Designers: Yael Amyra, Jeff Gimenez"),
                const Divider(),
                const Text("Lead Developer: Jason Stillwell")
              ],
            ),
          ]
      ),
    );
  }

}
