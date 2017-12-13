import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hythr/constants.dart';
import 'package:hythr/pages/user_select_page.dart';
import 'package:hythr/widgets/current_user.dart';
import 'package:hythr/content/user.dart';
import 'package:hythr/signin.dart';

class UserAvatar extends StatelessWidget {

  Widget build(BuildContext context) {
    final User user = CurrentUser.of(context);
    return new Row(
      children: <Widget>[
        user == null || user.photoUrl == null ? new Icon(Icons.mood) :
        new CircleAvatar(
          backgroundImage: new NetworkImage( user.photoUrl )
        ),
        new Text(user?.realName ?? 'Unknown')
      ]
    );
  }
}



class ApplicationMenu extends StatelessWidget {


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
            const ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
            new ListTile(
              leading: const Icon(Icons.time_to_leave),
              title: const Text('Logout'),
              onTap: () {
                userSignIn.signOut();
                SystemNavigator.pop();
              }
            ),
          ]
      ),
    );
  }

}
