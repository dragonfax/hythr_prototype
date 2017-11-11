import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'content/user.dart';
import 'tags_selection_page.dart';
import 'content/root.dart';
import 'page.dart';
import 'package:flutter/foundation.dart';
import 'content/client_note.dart';
import 'clients_tab_view.dart';

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
        leading: user.getProfilePicture(),
        title: new Text(user.realName),
        subtitle: new Column(children: [
          new Text(user.username),
        ]),
      ),
    ];

    if (!asClient ) {
      basicInfo.addAll([
        new Divider(),
        new ListTile(
            leading: new Text("Bio"),
            title: new Text(
                "I want to scream and shout and let it all out. Scream and shout and let it out. We sing oh we oh.")
        ),
      ]);
    }

    basicInfo.addAll([
      new Divider(),
      new ListTile(
        leading: new Icon(Icons.phone),
        title: new Text(user.phone ?? "XXX-XXX-XXXX"),
      ),
      new Divider(),
    ]);



    if ( !asClient && user.salon != null ) {
      basicInfo.addAll([
          new ListTile(
            leading: new Column(children: [
              new Icon(Icons.content_cut),
            ]),
            title: new Text(user.salon.name ?? ""),
            subtitle: new Text(user.salon.address +
              "\n" +
              user.salon.hours +
              "\n" +
              user.salon.phone
            ),
          ),
          new Divider()
      ]);
    }


    basicInfo.addAll([
      new ListTile(
        leading: new Icon(Icons.beach_access),
        title: new Text("Interests",
          style: new TextStyle(fontWeight: FontWeight.bold)
        ),
        subtitle: new Text(user.interests.join(", ")),
        onTap: !canEdit ? null : () {
          InterestsSelectionPage.show(context, user, root.interests);
        }
      ),
    ]);

    if ( !asClient) {
      basicInfo.addAll([
        new Divider(),
        new ListTile(
            leading: new Icon(Icons.content_cut),
            title: new Text("Skills",
                style: new TextStyle(fontWeight: FontWeight.bold)
            ),
            subtitle: new Text(user.skills.join(", ")),
            onTap: !canEdit ? null : () {
              SkillsSelectionPage.show(context, user, root.skills);
            }
        ),
      ]);
    }

    if ( !asClient ) {
      basicInfo.addAll([
        new Divider(),
        new ListTile(
            leading: new Icon(Icons.school),
            title: new Text("Certifications",
                style: new TextStyle(fontWeight: FontWeight.bold)),
            subtitle: new Text((user.certifications ?? []).join(", "))),
      ]);
    }

    if ( asClient ) {
      basicInfo.addAll([
        new Divider(),
        new ListTile(
          title: new Text("Notes & Photos", style: new TextStyle(fontWeight: FontWeight.bold))
        ),
      ]);

      List<ClientNote> notes = root.currentUser.clientNotes[user.username];

      if ( notes == null || notes.isEmpty ) {
        basicInfo.add(
          new ListTile(title: new Center(child: new Text("No notes")))
        );
      } else {
        basicInfo.addAll(
          notes.map((note){
            return note.getWidget();
          }).toList()
        );
      }
    }

    SliverList slist = new SliverList( delegate: new SliverChildListDelegate(basicInfo));

    return new Stack(children: [
      new Column(children: [
        new ContactClientButton(),
        new Expanded(
          child: new CustomScrollView(slivers: [slist])
        )
      ]),
      new AddClientContentSpeedDial()
    ]);
  }
}

class ContactClientButton extends StatelessWidget {

  showContactDialog(BuildContext context) async {
    showDialog<Null>(
      context: context,
      child: new AlertDialog(
        title: new Text('Contact Client'),
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
    return new ConstrainedBox(
        constraints: new BoxConstraints(minHeight: 20.0),
        child: new FlatButton(
            onPressed: () {
              showContactDialog(context);
            },
            child: new Text("Contact")
        )
    );
  }

}
