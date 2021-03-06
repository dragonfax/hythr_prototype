import 'package:flutter/material.dart';
import 'package:hythr/pages/page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'input_dialog.dart';
import 'package:hythr/content/user.dart';
import 'client_notes_page.dart';
import 'package:hythr/content/client.dart';
import 'package:hythr/widgets/current_user.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:hythr/constants.dart';

class ClientDirectorySidebar extends StatelessWidget {
  final List<String> letters;

  ClientDirectorySidebar(this.letters);

  @override
  build(context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: letters.map((letter) { return new Text(letter, style: new TextStyle( fontSize: 20.0, fontWeight: FontWeight.bold )); } ).toList()
    );
  }
}

class ClientDirectoryTile extends StatelessWidget {

  final String letter;

  ClientDirectoryTile(this.letter);

  @override
  build(context) {
    return new Container(
      color: Colors.grey[800],
      child: new ConstrainedBox(
        constraints: new BoxConstraints(minHeight: 30.0),
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new UnconstrainedBox(
            constrainedAxis: Axis.horizontal,
            child: new Row(children: [
              new Text(letter, style: new TextStyle(fontWeight: FontWeight.bold))
            ]),
          ),
        )
      )
    );
  }
}

class ClientsTabPage extends StatelessWidget {

  static show(BuildContext context) {
    new Page(title: "Clients", child: new ClientsTabPage()).show(context);
  }

  addClientFunc(User user, BuildContext context) async {
    var name = await new InputDialog(
        title: "Enter Client Name",
        actionLabel: "Create Client"
    ).show(context);

    var ref = await clientsRef(user).push();
    ref.set({ "name": name});
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

        clients.sort((Client a, Client b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()) );

        List<Widget> clientTiles = [];
        List<String> clientDirectory = [];

        if ( clients.isEmpty ) {
          clientTiles.add(const Center(child: const Text('0 clients')));
        } else {
          String prevLetter;
          clients.forEach((client) {
            var letter = client.name[0].toUpperCase();

            if ( prevLetter == null || prevLetter != letter) {
              clientDirectory.add(letter);
              clientTiles.add(new ClientDirectoryTile(letter));
              prevLetter = letter;
            } else {
              clientTiles.add(new Divider());
            }

            clientTiles.add(new ListTile(
              leading: client.getChip(),
              title: new Text(client.name),
              onTap: () {
                showClientNotes(user, context, client);
              },
            ));

          });
        }

        return new Stack(
          alignment: Alignment.centerRight,
          children: [
            new ListView(
              children: clientTiles
            ),
            new Positioned(
              right: 10.0,
              bottom:10.0,
              child: new AddClientContentMenu((context) => addClientFunc(user, context))
            ),
            new Positioned(
              child: new ClientDirectorySidebar(clientDirectory)
            )
          ]
        );
      }
    );
  }
}

class AddClientContentMenu extends StatelessWidget {
  final ContextCallback addClientFunc;

  AddClientContentMenu(this.addClientFunc);

  @override
  build(context) {
    return new FabDialer(
      [
        new FabMiniMenuItem(
          textColor: Colors.white,
          chipColor: Colors.blue,
          fabColor: Colors.blue,
            icon: new Icon(Icons.person_add),
            text: "Add Client",
            elevation: 4.0,
            tooltip: "Add a new Client",
            onPressed: () { debugPrint("calling function"); addClientFunc(context); } ,
        ),
        new FabMiniMenuItem(
            textColor: Colors.white,
            chipColor: Colors.blue,
            fabColor: Colors.blue,
            icon: new Icon(Icons.phone),
            text: "Import Client",
            elevation: 4.0,
            tooltip: "Add a new Client",
            onPressed: () {}
        ),
        new FabMiniMenuItem(
            textColor: Colors.white,
            chipColor: Colors.blue,
            fabColor: Colors.blue,
          icon: new Icon(Icons.message),
          text: "Message All Clients",
          elevation: 4.0,
          tooltip: "Message all Clients",
          onPressed: () {}
        ),
      ],
      Colors.blue,
      const Icon(Icons.add)
    );
  }
}
