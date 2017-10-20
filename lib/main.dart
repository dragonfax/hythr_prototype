import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' show JSON;
import 'dart:async' show Future;

Future<DataRoot> readContent() async {
  String contentJson = await rootBundle.loadString('assets/content.json');

  var json = JSON.decode(contentJson);

  return new DataRoot.fromJson(json);
}


class Stylist {
  String username;
  String realName;
  String photo;
  List<String> clients;

  Stylist.fromJson(Map json) {
    username = json['username'];
    realName = json['real_name'];
    photo = json['photo'];

    clients = [];
    json['clients'].forEach((clientName){
      clients.add(clientName);
    });
  }
}

class HairClient {
  String username;
  String realName;
  String photo;

  HairClient.fromJson(Map json) {
    username = json['username'];
    realName = json['real_name'];
    photo = json['photo'];
  }
}

class DataRoot {
  String user;
  Map<String,Stylist> stylists;
  Map<String,HairClient> clients;

  DataRoot() {
    stylists = new Map();
    clients = new Map();
  }

  DataRoot.fromJson(Map json) {
    user = json['user'];

    stylists = new Map();
    json['stylists'].forEach((stylistData) {
      stylists[stylistData['username']] = new Stylist.fromJson(stylistData);
    });

    clients = new Map();
    json['clients'].forEach((clientData) {
      clients[clientData['username']] = new HairClient.fromJson(clientData);
    });

  }
}

void main() {
  runApp(new MyApp());
}

enum AddButtons { post, video, selfie, clientNote }

final String appTitle = 'HAIRAPPi';

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

    return new DefaultTabController( length: 3, child: new Scaffold(
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
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: new Row(
                children: <Widget>[
                  new Icon(Icons.mood),
                  new Text( root.user != null ? root.stylists[root.user].realName : 'None')
                ]
              )
            ),
            new ListTile(
              title: new Text('Your Profile')
            ),
            new ListTile(
              title: new Text('Settings'),
            ),
            new ListTile(
              title: new Text('Logout'),
            ),
            new AboutListTile(
              applicationName: 'tHairepy'
            ),
          ]
        ),
      ),

      body: new TabBarView(
        children: [
          root.stylists.isEmpty ? new Center( child: new Text('0 collegues') ) :
            new ListView(
              itemExtent: 200.0,
              children: root.stylists.values.map( (stylist) {
                return new Row(
                  children: [
                    new Image.asset(stylist.photo),
                    new Text(stylist.realName)
                  ]
                );
              }).toList()
            ),
          root.clients.isEmpty ? new Center( child: new Text('0 clients') ) :
            new ListView(
              itemExtent: 200.0,
              children: root.clients.values.map( (client) {
                return new Row(
                    children: [
                      new Image.asset(client.photo),
                      new Text(client.realName)
                    ]
                );
              }).toList()
            ),
          root.clients.isEmpty ? new Center( child: new Text('0 notifications')) :
            new ListView(
              itemExtent: 100.0,
              children: [
                new Row(
                    children: [
                      new Icon(Icons.mail),
                      new Expanded( child: new Text("Your client ${root.clients.values.first.realName} would like to schedule an appointment.", softWrap: true, overflow: TextOverflow.ellipsis))
                    ]
                ),
                new Row(
                  children: [
                    new Icon(Icons.people),
                    new Expanded( child: new Text("Your connection ${root.stylists.values.first.realName} has referred a client ${root.clients.values.last.realName} to you.", softWrap: true, overflow: TextOverflow.ellipsis))
                  ]
                )
              ]
            )
        ]
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Add Content',
        child: new PopupMenuButton<AddButtons>(
          itemBuilder: (BuildContext context) => <PopupMenuEntry<AddButtons>>[
            new PopupMenuItem<AddButtons>(
                value: AddButtons.post,
                child: new Text('Add Image to Work Gallery')
            ),
            new PopupMenuItem<AddButtons>(
                value: AddButtons.selfie,
                child: new Text('Take a new Profile Pic')
            ),
            new PopupMenuItem<AddButtons>(
              value: AddButtons.clientNote,
              child: new Text('Add to Client Log')
            ),
            new PopupMenuItem<AddButtons>(
              value: AddButtons.video,
              child: new Text('Add a new Story/Video')
            )
          ]
        )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}
