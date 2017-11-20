import 'package:flutter/material.dart';
import 'package:hythr/pages/notifications_tab_view.dart';
import 'package:flutter/widgets.dart';
import 'package:hythr/pages/clients_tab_view.dart';
import 'package:hythr/pages/personal_portfolio_view.dart';
import 'package:hythr/pages/inspiration_gallery_view.dart';
import 'package:hythr/widgets/yellow_divider.dart';
import 'package:hythr/pages/profile_widget.dart';
import 'package:hythr/widgets/add_content_speed_dial.dart';
import 'package:hythr/pages/timeline_widget.dart';
import 'package:hythr/widgets/application_menu.dart';
import 'package:hythr/content/content.dart';
import 'stylist_search_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  loadContent() async {
    DataRoot newRoot = await readContent();
    setState(() {
      root = newRoot;
      debugPrint("home page reassembled");
    });
  }

  @override
  initState() {
    super.initState();
    loadContent();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Stylist Home"),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              tooltip: "Notifications",
              onPressed: () { NotificationsTabView.show(context); }
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
    return new ListView(children: [
          new ListTile(
            leading: const Icon(Icons.timeline),
            title: const Text("Timeline"),
            onTap: () { TimeLineWidget.show(context); }
          ),
          new ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Stylist Profile"),
            onTap: () { ProfileWidget.show(context, root.currentUser, true, false); },
          ),
          new ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text("Clients"),
            onTap: () { ClientsTabView.show(context); },
          ),
          new ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text("Personal Portfolio"),
            onTap: () { PersonalPortfolioView.show(context); },
          ),
          new ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text("Inspiration"),
            onTap: () { InspirationGalleryView.show(context); },
          ),
          new ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Find a Stylist"),
            onTap: () { StylistSearchPage.show(context, root.currentUser); },
          )
        ]);
  }
}