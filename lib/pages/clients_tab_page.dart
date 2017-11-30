import 'package:flutter/material.dart';
import '../content/content.dart';
import 'package:hythr/pages/profile_page.dart';
import 'package:hythr/pages/page.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';

class ClientsTabPage extends StatelessWidget {
  static show(BuildContext context) {
    new Page(title: "Clients", child: new ClientsTabPage()).show(context);
  }

  Widget getTab() {
    return const Tab(text: 'Clients', icon: const Icon(Icons.people));
  }

  showClientProfilePanel(BuildContext context, User client) {
    new Page(title: client.realName, child: new ProfilePage(user: client, canEdit: false, asClient: true)).show(context);
  }

  showContactAll(BuildContext context) async {
    showDialog<Null>(
      context: context,
      child: new AlertDialog(
        title: const Text('Contacting All Clients'),
        content: const TextField(),
        actions: [
          new FlatButton(onPressed: () { Navigator.of(context).pop(); }, child: const Text("Cancel")),
          new FlatButton(onPressed: () { Navigator.of(context).pop(); }, child: const Text("Send"))
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (root.currentUser == null ||
        root.currentUser.clients == null ||
        root.currentUser.clients.isEmpty) {
      return const Center(child: const Text('0 clients'));
    } else {
      return new Column(
        children: [
          new ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 20.0),
            child: new FlatButton(
              onPressed: () { showContactAll(context); },
              child: const Text("Contact All")
            )
          ),
          new Expanded(
            child: new Stack(
              children: [
                new ListView(
                  itemExtent: 100.0,
                  children: root.currentUser.clients.map((clientName) {
                    User client = root.users[clientName];
                    return new ListTile(
                        leading: client.getChip(),
                        title: new Text(client.realName),
                        onTap: () { showClientProfilePanel(context, client); }
                    );
                  }).toList()
                ),
                const AddClientContentSpeedDial()
              ]
            )
          )
        ]
      );
    }
  }
}

class AddClientContentSpeedDial extends StatelessWidget {

  const AddClientContentSpeedDial();

  @override
  Widget build(BuildContext context) {

    return const FabDialer(const [
      const FabMiniMenuItem(
        text: "Add Client Note",
        elevation: 4.0
      ),
      const FabMiniMenuItem(
        text: "Add Client Photo",
        elevation: 4.0
      ),
    ], Colors.blue, const Icon(Icons.add));
  }
}