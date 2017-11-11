import 'package:flutter/material.dart';
import 'content/user.dart';
import 'profile_widget.dart';
import 'client_notes_widget.dart';
import 'content/root.dart';
import 'yellow_divider.dart';

class ClientsTabView extends StatelessWidget {
  static show(BuildContext context) {
    Navigator
        .of(context)
        .push(new MaterialPageRoute<Null>(builder: (BuildContext context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text("Clients")),
          body: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                new YellowDivider(),
                new Expanded(child: new ClientsTabView())
              ]));
    }));
  }

  Widget getTab() {
    return new Tab(text: 'Clients', icon: new Icon(Icons.people));
  }

  showClientProfilePanel(BuildContext context, User client) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(title: new Text(client.realName)),
            body: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  new YellowDivider(),
                  new Expanded(child: new ProfileWidget())
                ]));
      },
    ));
  }

  showContactAll(BuildContext context) async {
    showDialog<Null>(
      context: context,
      child: new AlertDialog(
        title: new Text('Contacting All Clients'),
        content: new TextField(),
        actions: [
          new FlatButton(onPressed: () { Navigator.of(context).pop(); }, child: new Text("Cancel")),
          new FlatButton(onPressed: () { Navigator.of(context).pop(); }, child: new Text("Send"))
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (root.currentUser == null ||
        root.currentUser.clients == null ||
        root.currentUser.clients.isEmpty) {
      return new Center(child: new Text('0 clients'));
    } else {
      return new Column(children: [
        new ConstrainedBox(
            constraints: new BoxConstraints(minHeight: 20.0),
            child: new FlatButton(
                onPressed: () { showContactAll(context); }, child: new Text("Contact All"))),
        new Expanded(
            child: new ListView(
                itemExtent: 100.0,
                children: root.currentUser.clients.map((clientName) {
                  User client = root.users[clientName];
                  return new ListTile(
                      leading: client.getProfilePicture(),
                      title: new Text(client.realName),
                      // onTap: () { showClientProfilePanel(context, client); }
                      onTap: () {
                        ClientNotesWidget.show(
                            context,
                            root.currentUser.clientNotes[client.username],
                            client.realName);
                      });
                }).toList()))
      ]);
    }
  }
}
