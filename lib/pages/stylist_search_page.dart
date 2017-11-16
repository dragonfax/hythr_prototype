import 'package:flutter/material.dart';
import 'page.dart';
import '../content/user.dart';
import '../content/root.dart';
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


  Widget build(BuildContext context) {
    return new ListView(
        children: [
          new SearchWidget(),
          const Divider(),
        ]..addAll(root.stylists().map(( User u){
          return new Column(children: [
            new Row(
            children: [
              new Padding(
                child: u.getChip(),
                padding: new EdgeInsets.symmetric(horizontal: 10.0)
              ),
              new Expanded(child: new Text(u.realName)),
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
        }))
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
