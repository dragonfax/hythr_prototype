import 'package:flutter/material.dart';
import 'package:hythr/constants.dart';
import 'package:hythr/pages/user_select_page.dart';
import 'package:hythr/widgets/current_user.dart';
import 'package:hythr/content/user.dart';
import 'package:hythr/signin.dart';
import 'package:hythr/pages/settings_page.dart';
import 'package:cached_network_image/cached_network_image.dart';


class UserAvatar extends StatelessWidget {

  Widget build(BuildContext context) {
    final User user = CurrentUser.of(context);
    return new Row(
      children: <Widget>[
        user == null || user.photoUrl == null ? new Icon(Icons.mood) :
        new CircleAvatar(
          backgroundImage: new CachedNetworkImageProvider( user.photoUrl )
        ),
        new Text(user?.realName ?? 'Unknown')
      ]
    );
  }
}



class ApplicationMenu extends StatelessWidget {

  openSettings(BuildContext context) {
    new SettingsPage().show(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
          children: <Widget>[
            new DrawerHeader( child: new UserAvatar() ),
            const AboutListTile(
              icon: const Icon(Icons.info),
              applicationName: appTitle,
              aboutBoxChildren: const [
                const Text("Lead Designers: Yael Amyra, Jeff Gimenez"),
                const Divider(),
                const Text("Lead Developer: Jason Stillwell")
              ],
            ),
            new ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Select User"),
              onTap: () {
                UserSelectPage.show(context);
              }
            ),
            new ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                openSettings(context);
              }
            ),
            new ListTile(
              leading: const Icon(Icons.time_to_leave),
              title: const Text('Logout'),
              onTap: () {
                userSignIn.signOut();
              }
            ),
          ]
      ),
    );
  }

}
