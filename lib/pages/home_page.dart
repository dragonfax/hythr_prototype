import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hythr/pages/clients_tab_page.dart';
import 'package:hythr/pages/personal_portfolio_page.dart';
import 'package:hythr/pages/inspiration_gallery_page.dart';
import 'package:hythr/widgets/yellow_divider.dart';
import 'package:hythr/pages/profile_page.dart';
import 'package:hythr/widgets/add_content_speed_dial.dart';
import 'package:hythr/widgets/application_menu.dart';
import 'stylist_search_page.dart';
import 'package:hythr/widgets/current_user.dart';
import 'package:hythr/content/user.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Stylist Home"),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              tooltip: "Notifications",
              onPressed: null
          )
        ],
      ),
      drawer: new ApplicationMenu(),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const YellowDivider(),
          new Expanded(child: new Stack(
            children: [
              new MainMenu(),
              new AddContentSpeedDial()
            ]
          ))
        ]
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    User user = CurrentUser.of(context);
    return new ListView(children: [
          new ListTile(
            leading: const Icon(Icons.timeline),
            title: const Text("Timeline"),
            onTap: null,
          ),
          new ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Your Profile"),
            onTap: () { ProfilePage.show(context, user, true, false, true); },
          ),
          new ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text("Clients"),
            onTap: () { ClientsTabPage.show(context,user); },
          ),
          new ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text("Personal Portfolio"),
            onTap: () { PersonalPortfolioPage.show(context); },
          ),
          new ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text("Inspiration"),
            onTap: () { InspirationGalleryPage.show(context); },
          ),
          new ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Find a Stylist"),
            onTap: () { StylistSearchPage.show(context, user); },
          )
        ]);
  }
}