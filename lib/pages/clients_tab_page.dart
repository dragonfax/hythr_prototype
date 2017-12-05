import 'package:flutter/material.dart';
import 'package:hythr/pages/page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'input_dialog.dart';
import 'package:hythr/content/user.dart';

class Client {
  String key;
  String name;
  String photoUrl;

  Client.fromFirebaseSnapshot(String k, Map value) {
    key = k;
    name = value['name'];
    photoUrl = value['photo_url'];
  }

  Widget getChip() {
    if ( photoUrl != null ) {
      return new CircleAvatar(
          backgroundImage: new NetworkImage( photoUrl )
      );
    } else {
      return new CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          child: new Text(getInitials(name))
      );
    }
  }

}

class ClientsTabPage extends StatelessWidget {
  final User user;

  ClientsTabPage(this.user);

  static show(BuildContext context, User user) {
    new Page(title: "Clients", child: new ClientsTabPage(user)).show(context);
  }

  addClientFunc(BuildContext context) {
    return () async {
      var name = await new InputDialog(
          title: "Enter Client Name",
          actionLabel: "Create Client"
      ).show(context);

      var ref = await clientsRef().push();
      ref.set({ "name": name});
    };
  }

  clientsRef() {
    return FirebaseDatabase.instance.reference().child(
        "clients/" + user.googleId);
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<Event>(
      stream: clientsRef().onValue,
      builder: (BuildContext context, AsyncSnapshot<Event> asyncSnapshot) {

        List<Client> clients = ( asyncSnapshot?.data?.snapshot?.value?.keys ?? <String>[]).map((key) {
          var value = asyncSnapshot.data.snapshot.value[key];
          return new Client.fromFirebaseSnapshot(key, value);
        }).toList();

        return new Column(
            children: [
              new ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 20.0),
                  child: new FlatButton(
                      onPressed: addClientFunc(context),
                      child: const Text("Add New Client")
                  )
              ),
              new Expanded(
                  child: new Stack(
                      children: [
                        new ListView(
                          itemExtent: 100.0,
                          children: clients.isEmpty ?
                            [ const Center(child: const Text('0 clients')) ] :
                            clients.map((client) {
                              return new ListTile(
                                  leading: client.getChip(),
                                  title: new Text(client.name),
                                  onTap: () {
                                    // showClientProfilePanel(context, client);
                                  }
                              );
                            }).toList()
                        ),
                      ]
                  )
              )
            ]
        );
      }
    );
  }
}
