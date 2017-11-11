import 'package:flutter/material.dart';
import 'content/root.dart';
import 'content/user.dart';
import 'yellow_divider.dart';

class InspirationGalleryView extends StatelessWidget {

  static show(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new Scaffold(
          appBar: new AppBar(title: new Text("Inspiration")),
          body: new Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [ new YellowDivider(), new Expanded( child: new InspirationGalleryView()) ])
        );
      }
    ));
  }

  Widget build(BuildContext context) {
    List<Widget> slivers = [];

    User user = root.currentUser;

    slivers.addAll([
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
