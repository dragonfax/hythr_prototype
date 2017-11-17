import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../content/content.dart';
import 'page.dart';
import 'package:flutter/foundation.dart';
import 'clients_tab_view.dart';
import 'interests_selection_page.dart';
import 'skills_selection_page.dart';

class ProfileWidget extends StatelessWidget {
  final bool canEdit;
  final User user;
  final bool asClient; // otherwise as-stylist

  ProfileWidget({ @required this.user, this.canEdit = false, this.asClient = false });

  static show(BuildContext context, User user, bool canEdit, bool asClient) {
    new Page(title: "Stylist Profile", child: new ProfileWidget(user: user, canEdit: canEdit, asClient: asClient)).show(context);
  }

  @override
  Widget build(BuildContext context) {


    // initial tiles with basic user info for the first sliver.
    List<Widget> basicInfo = [
      new ListTile(
        leading: user.getChip(),
        title: new Text(user.realName),
        subtitle: new Column(children: [
          new Text(user.username),
        ]),
      ),
    ];

    if (!asClient ) {
      basicInfo.addAll(const [
        const Divider(),
        const ListTile(
            leading: const Text("Bio"),
            title: const Text(
                "I want to scream and shout and let it all out. Scream and shout and let it out. We sing oh we oh.")
        ),
      ]);
    }

    basicInfo.addAll([
      const Divider(),
      new ListTile(
        leading: const Icon(Icons.phone),
        title: new Text(user.phone ?? "XXX-XXX-XXXX"),
      ),
      const Divider(),
      new ListTile(
        leading: const Icon(Icons.message),
        title: new Text("Send message"),
        onTap: () {
          ContactClientButton.showContactDialog(context);
        }
      ),
      const Divider(),
    ]);



    if ( !asClient && user.salon != null ) {
      basicInfo.addAll([
          new ListTile(
            leading: new Column(children: const [
              const Icon(Icons.content_cut),
            ]),
            title: new Text(user.salon.name ?? ""),
            subtitle: new Text(user.salon.address +
              "\n" +
              user.salon.hours +
              "\n" +
              user.salon.phone
            ),
          ),
          const Divider()
      ]);
    }


    basicInfo.addAll([
      new ListTile(
        leading: const Icon(Icons.book),
        title: const Text("Interests" ),
        subtitle: new Text(user.interests.join(", ")),
        onTap: !canEdit ? null : () {
          InterestsSelectionPage.show(context, user);
        }
      ),
      new ListTile(
        leading: const Icon(Icons.merge_type),
        title: const Text("Hair Type")
      ),
    ]);

    if ( !asClient) {
      basicInfo.addAll([
        new Divider(),
        new ListTile(
            leading: const Icon(Icons.content_cut),
            title: const Text("Skills" ),
            subtitle: new Text(user.skills.join(", ")),
            onTap: !canEdit ? null : () {
              SkillsSelectionPage.show(context, user);
            }
        ),
      ]);
    }

    if ( !asClient ) {
      basicInfo.addAll([
        const Divider(),
        new ListTile(
            leading: const Icon(Icons.school),
            title: const Text("Certifications"),
            subtitle: new Text((user.certifications ?? []).join(", "))),
      ]);
    }

    basicInfo.addAll([
      const Divider(),
      new ListTile(
        leading: const Icon(Icons.person_outline),
        title: new Text("Personal photos"),
      ),
      const Divider(),
      new ListTile(
        leading: const Icon(Icons.star),
        title: new Text("Inspiration photos")
      ),
    ]);

    if ( asClient ) {
      basicInfo.addAll(const [
        const Divider(),
        const ListTile(
          leading: const Icon(Icons.note),
          title: const Text("Your Notes & Photos")
        ),
      ]);
    }

    /*
      List<ClientNote> notes = root.currentUser.clientNotes[user.username];

      if ( notes == null || notes.isEmpty ) {
        basicInfo.add(
          const ListTile(title: const Center(child: const Text("No notes")))
        );
      } else {
        basicInfo.addAll(
          notes.map((note){
            return note.getWidget();
          }).toList()
        );
      }
    } */

    SliverList slist = new SliverList( delegate: new SliverChildListDelegate(basicInfo));

    return new Stack(children: [
      new CustomScrollView(slivers: [slist]),
      const AddClientContentSpeedDial()
    ]);
  }
}

class ContactClientButton {

  static showContactDialog(BuildContext context) async {
    showDialog<Null>(
      context: context,
      child: new AlertDialog(
        title: const Text('Contact Client'),
        content: const TextField(),
        actions: [
          new FlatButton(onPressed: () { Navigator.of(context).pop(); }, child: const Text("Cancel")),
          new FlatButton(onPressed: () { Navigator.of(context).pop(); }, child: const Text("Send"))
        ]
      )
    );
  }
}
