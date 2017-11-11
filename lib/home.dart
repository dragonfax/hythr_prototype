import 'package:flutter/material.dart';
import 'notifications_tab_view.dart';
import 'application_menu.dart';
import 'content/root.dart';
import 'clients_tab_view.dart';
import 'personal_portfolio_view.dart';
import 'inspiration_gallery_view.dart';
import 'package:flutter/widgets.dart';
import 'yellow_divider.dart';
import 'profile_widget.dart';
import 'add_content_speed_dial.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  loadContent() async {
    DataRoot newRoot = await readContent();
    setState(() {
      root = newRoot;
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
              icon: new Icon(Icons.notifications, color: Colors.white),
              tooltip: "Notifications",
              onPressed: () { NotificationsTabView.show(context); }
          )
        ],
      ),
      drawer: new ApplicationMenu(),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          new YellowDivider(),
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
            leading: new Icon(Icons.person),
            title: new Text("Stylist Profile"),
            onTap: () { ProfileWidget.show(context, root.currentUser, true, false); },
          ),
          new ListTile(
            leading: new Icon(Icons.people_outline),
            title: new Text("Clients"),
            onTap: () { ClientsTabView.show(context); },
          ),
          new ListTile(
            leading: new Icon(Icons.photo_camera),
            title: new Text("Personal Portfolio"),
            onTap: () { PersonalPortfolioView.show(context); },
          ),
          new ListTile(
            leading: new Icon(Icons.photo_album),
            title: new Text("Inspiration"),
            onTap: () { InspirationGalleryView.show(context); },
          ),
        ]);
  }
}