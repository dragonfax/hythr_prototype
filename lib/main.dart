import 'package:flutter/material.dart';
// import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';

import 'add_content_button.dart';
import 'content.dart';
import 'application_menu.dart';
import 'collegues_tab_view.dart';
import 'clients_tab_view.dart';
import 'notifications_tab_view.dart';

final String appTitle = 'HAIRAPPi';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataRoot root = new DataRoot();

  loadContent() async {
    try {
      DataRoot newRoot = await readContent();

      setState(() {
        root = newRoot;
      });
    }
    catch (e) {
      debugPrint(e);
    }
  }

  @override
  initState() {
    super.initState();

    loadContent();
  }

  @override
  Widget build(BuildContext context) {

    return new DefaultTabController(
      length: 3,
      child: new Scaffold(

        appBar: new AppBar(
          title: new Text(widget.title),
          bottom: new TabBar(
            tabs: [
              new Tab(
                text: 'Collegues',
                icon: new Icon(Icons.group_work)
              ),
              new Tab(
                text: 'Clients',
                icon: new Icon(Icons.people)
              ),
              new Tab(
                  text: 'Notifications',
                  icon: new Icon(Icons.notifications)
              ),
            ]
          )
        ),

        drawer: new ApplicationMenu(root.currentUser?.realName, appTitle),

        body: new TabBarView(
          children: [
            new ColleguesTabView(root.stylists.values.toList()),
            new ClientsTabView(root.clients.values.toList()),
            new NotificationsTabView(root.currentUser.notifications)
          ]
        ),

        floatingActionButton: new FloatingAddButton(),
      )
    );
  }
}
