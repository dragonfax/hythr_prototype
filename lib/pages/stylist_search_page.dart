import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'page.dart';
import 'package:hythr/content/user.dart';
import 'dart:math';

final rng = new Random();

class StylistSearchPage extends StatelessWidget {

  static show(BuildContext context, User user) {
    new Page(
        title: "Star Search",
        child: new StylistSearchPage(user)).show(context);
  }

  final User user;

  StylistSearchPage(this.user);

  buildStylistTile(User stylist) {
    return new Column(children: [
      new Row(
      children: [
        new Padding(
          child: stylist.getChip(),
          padding: new EdgeInsets.symmetric(horizontal: 10.0)
        ),
        new Expanded(child: new Text(stylist.realName)),
        new Column(children: [
          new Row(children: [
            new Padding(
              child: new ImageIcon(new AssetImage("assets/icons/puzzle_piece.png")),
              padding: new EdgeInsets.symmetric(horizontal: 10.0)
            ),
            new Text(rng.nextInt(10).toString())
          ]),
          new Row(children: [
            new Padding(
              child: new ImageIcon(new AssetImage("assets/icons/heart.png")),
              padding: new EdgeInsets.symmetric(horizontal: 10.0)
            ),
            new Text(rng.nextInt(10).toString())
          ])
        ]),
        new Padding(
          padding: new EdgeInsets.symmetric(horizontal: 10.0),
          child: new Text( ( rng.nextDouble() * 10 ).toStringAsFixed(1) + " mi")
        )
      ]
    ),
    const Divider()
    ]);
  }


  Widget build(BuildContext context) {
    return new Column(
      children: [
        new SearchWidget(),
        const Divider(),
        new Expanded(child:new FirebaseAnimatedList(
          query: FirebaseDatabase.instance.reference().child("users"),
          itemBuilder: (context, snapshot, animation, index) {
            User stylist = new User.fromFirebaseSnapshot(snapshot);
            return buildStylistTile(stylist);
          }
        ))
      ]
    );
  }

}

class SearchWidget extends StatelessWidget {

  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Row(children: [
          new Icon(Icons.search, color: Colors.grey[600], size: 32.0),
          new Padding(padding: const EdgeInsets.only(left: 16.0)),
          new Flexible(child: new Stack(children: [
              new Positioned(
                left: 0.0,
                top: 0.0,
                child: new Text("search", style: new TextStyle(fontStyle: FontStyle.italic)),
            ),
            new TextField(),
          ]))
        ]
      )
    );
  }
}
