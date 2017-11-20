import 'package:flutter/material.dart';
import 'package:hythr/constants.dart';
import 'package:hythr/google_signin.dart';
import 'package:flutter/services.dart';

class UserAvatar extends StatefulWidget {
  @override
  UserAvatarState createState() => new UserAvatarState();
}

class UserAvatarState extends State<UserAvatar> {

  UserAvatarState() {
    googleSignIn.onCurrentUserChanged.listen((e) {
      debugPrint("received a user change");
      setState(() {});
    });
  }

  Widget build(BuildContext context) {

    return new Row(
      children: <Widget>[
        googleSignIn.currentUser == null ? new Icon(Icons.mood) :
        new CircleAvatar(
          backgroundImage: new NetworkImage(
            googleSignIn.currentUser.photoUrl )
        ),
        new Text(googleSignIn.currentUser?.displayName ?? 'Not Logged In')
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
            const ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
            new ListTile(
              leading: const Icon(Icons.time_to_leave),
              title: const Text('Logout'),
              onTap: () {
                googleSignIn.signOut();
                SystemNavigator.pop();
              }
            ),
          ]
      ),
    );
  }

}