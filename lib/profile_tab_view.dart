import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'content.dart';

class ProfileTabView extends StatelessWidget {
  final User stylist;

  ProfileTabView(this.stylist);

  Widget getTab() {
    return new Tab(text: 'Your Profile', icon: new Icon(Icons.person));
  }

  @override
  Widget build(BuildContext context) {
    if (stylist == null) {
      return new Center(child: new Text("Nothing yet."));
    } else {
      return new CustomScrollView(slivers: [
        new SliverList(
            delegate: new SliverChildListDelegate([
          new ListTile(
            leading: stylist.getProfilePicture(),
            title: new Text(stylist.realName),
            subtitle: new Text(stylist.username),
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(Icons.phone),
            title: new Text(stylist.phone),
          ),
          new Divider(),
          new ListTile(
              leading: new Column(children: [
                new Icon(Icons.content_cut),
              ]),
              title: new Text(stylist.salon.name),
              subtitle: new Text(stylist.salon.address +
                  "\n" +
                  stylist.salon.hours +
                  "\n" +
                  stylist.salon.phone)),
          new Divider(),
          new ListTile(
              leading: new Icon(Icons.beach_access),
              title: new Text("Interests",
                  style: new TextStyle(fontWeight: FontWeight.bold)),
              subtitle: new Text(stylist.interests.join(", "))),
          new Divider(),
          new ListTile(
              leading: new Icon(Icons.school),
              title: new Text("Certifications",
                  style: new TextStyle(fontWeight: FontWeight.bold)),
              subtitle: new Text((stylist.certifications ?? []).join(", "))),
          new Divider(),
          new ListTile(
            leading: new Icon(Icons.person_outline),
            title: new Text("Profile Gallery", style: new TextStyle(fontWeight: FontWeight.bold))
          )
        ])),
        new SliverGrid(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
            delegate: new SliverChildListDelegate(
              stylist.gallery.where( (p) {
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
                stylist.gallery.where( (p) {
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
              stylist.gallery.where( (p) {
                return !p.isClient && !p.wasProfile && !p.isProfile;
              }).map((p) {
              return new Padding(
                  child: new Image.asset(p.asset),
                  padding: new EdgeInsets.all(8.0));
            }).toList())),
      ]);
    }
  }
}
