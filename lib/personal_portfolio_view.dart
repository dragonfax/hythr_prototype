import 'package:flutter/material.dart';
import 'content/root.dart';
import 'content/user.dart';
import 'page.dart';

class PersonalPortfolioView extends StatelessWidget {

  static show(BuildContext context) {
    new Page(title: "Personal Porfolio", child: new PersonalPortfolioView()).show(context);
  }

  Widget build(BuildContext context) {
    List<Widget> slivers = [];
    List<Widget> basicInfo = [];

    User user = root.currentUser;

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
    ]);

    return new CustomScrollView(slivers: slivers);
  }
}