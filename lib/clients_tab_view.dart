import 'package:flutter/material.dart';
import 'content/user.dart';
import 'profile_widget.dart';
import 'content/root.dart';
import 'page.dart';

class ClientsTabView extends StatelessWidget {
  static show(BuildContext context) {
    new Page(title: "Clients", child: new ClientsTabView()).show(context);
  }

  Widget getTab() {
    return new Tab(text: 'Clients', icon: new Icon(Icons.people));
  }

  showClientProfilePanel(BuildContext context, User client) {
    new Page(title: client.realName, child: new ProfileWidget(user: client, canEdit: false, asClient: true)).show(context);
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
                onPressed: () { showContactAll(context); },
                child: new Text("Contact All")
            )
        ),
        new Expanded(
            child: new ListView(
                itemExtent: 100.0,
                children: root.currentUser.clients.map((clientName) {
                  User client = root.users[clientName];
                  return new ListTile(
                      leading: client.getProfilePicture(),
                      title: new Text(client.realName),
                      onTap: () { showClientProfilePanel(context, client); }
                  );
                }).toList()))
      ]);
    }
  }
}
