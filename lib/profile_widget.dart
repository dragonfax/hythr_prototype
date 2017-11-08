import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'content.dart';
import 'skills_selection_page.dart';
import 'set_state_callback.dart';


class ProfileWidget extends StatelessWidget {
  final User user;
  final SetStateCallback userChangingCallback;

  ProfileWidget(this.user, this.userChangingCallback);

  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = [];

    // initial tiles with basic user info for the first sliver.
    List<Widget> basicInfo = [
      new ListTile(
        leading: user.getProfilePicture(),
        title: new Text(user.realName),
        subtitle: new Column(children: [
          new Text(user.username),
          new Text(user.isStylist ? "(stylist)" : "", style: new TextStyle(fontStyle: FontStyle.italic))
        ]),
      ),
      new Divider(),
      new ListTile(
        leading: new Icon(Icons.phone),
        title: new Text(user.phone ?? "XXX-XXX-XXXX"),
      ),
      new Divider(),
    ];


    if ( user.isStylist && user.salon != null ) {
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
                user.salon.phone)
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
        subtitle: new Text(user.interests.join(", "))
      ),
      new Divider(),
      new ListTile(
        leading: new Icon(Icons.content_cut),
        title: new Text("Skills",
          style: new TextStyle(fontWeight: FontWeight.bold)
        ),
        subtitle: new Text(user.skills.join(", ")),
        onTap: () {
          SkillsSelectionPage.show(context, user);
        }
      ),
      new Divider(),
    ]);

    if (user.isStylist ) {
      basicInfo.addAll([
        new ListTile(
            leading: new Icon(Icons.school),
            title: new Text("Certifications",
                style: new TextStyle(fontWeight: FontWeight.bold)),
            subtitle: new Text((user.certifications ?? []).join(", "))),
        new Divider()
      ]);
    }

    basicInfo.add(
      new ListTile(
        leading: new Icon(Icons.person_outline),
        title: new Text("Profile Gallery", style: new TextStyle(fontWeight: FontWeight.bold))
      )
    );

    slivers.add(new SliverList( delegate: new SliverChildListDelegate(basicInfo)));


    slivers.addAll([
        new SliverGrid(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
            delegate: new SliverChildListDelegate(
              user.gallery.where( (p) {
                return p.wasProfile || p.isProfile;
              }).map((p) {
              return new Padding(
                  child: new Image.asset(p.asset),
                  padding: new EdgeInsets.all(8.0));
            }).toList())),
        new SliverList(
            delegate: new SliverChildListDelegate([
              new ListTile(
                  leading: new Icon(Icons.people),
                  title: new Text("Client Gallery", style: new TextStyle(fontWeight: FontWeight.bold))
              )])),
        new SliverGrid(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
            delegate: new SliverChildListDelegate(
                user.gallery.where( (p) {
                  return p.isClient;
                }).map((p) {
                  return new Padding(
                      child: new Image.asset(p.asset),
                      padding: new EdgeInsets.all(8.0));
                }).toList())),
        new SliverList(
          delegate: new SliverChildListDelegate([
          new ListTile(
            leading: new Icon(Icons.brush),
            title: new Text("Style Gallery", style: new TextStyle(fontWeight: FontWeight.bold))
          )])),
        new SliverGrid(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
            delegate: new SliverChildListDelegate(
              user.gallery.where( (p) {
                return !p.isClient && !p.wasProfile && !p.isProfile;
              }).map((p) {
              return new Padding(
                  child: new Image.asset(p.asset),
                  padding: new EdgeInsets.all(8.0));
            }).toList())),
    ]);

    return new CustomScrollView(slivers: slivers);
  }
}
