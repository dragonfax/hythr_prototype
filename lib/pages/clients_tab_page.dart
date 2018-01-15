import 'package:flutter/material.dart';
import 'package:hythr/pages/page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'input_dialog.dart';
import 'package:hythr/content/user.dart';
import 'client_notes_page.dart';
import 'package:hythr/content/client.dart';
import 'package:hythr/widgets/current_user.dart';


class ClientsTabPage extends StatelessWidget {

  static show(BuildContext context, User user) {
    new Page(title: "Clients", child: new ClientsTabPage()).show(context);
  }

  addClientFunc(User user, BuildContext context) {
    return () async {
      var name = await new InputDialog(
          title: "Enter Client Name",
          actionLabel: "Create Client"
      ).show(context);

      var ref = await clientsRef(user).push();
      ref.set({ "name": name});
    };
  }

  clientsRef(User user) {
    return FirebaseDatabase.instance.reference().child(
        "clients/" + user.googleId);
  }

  showClientNotes(User user, BuildContext context, Client client) {
    new ClientNotesPage(user, client).show(context);
  }

  @override
  Widget build(BuildContext context) {

    User user = CurrentUser.of(context);
    return new StreamBuilder<Event>(
      stream: clientsRef(user).onValue,
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
                      onPressed: addClientFunc(user, context),
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
                                    showClientNotes(user, context, client);
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
