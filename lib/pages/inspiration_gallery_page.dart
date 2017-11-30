import 'package:flutter/material.dart';
import '../content/content.dart';
import 'package:hythr/pages/page.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';


class InspirationGalleryPage extends StatelessWidget {

  static show(BuildContext context) {
    new Page(title: "Inspiration", child: new InspirationGalleryPage()).show(context);
  }

  Widget build(BuildContext context) {
    List<Widget> slivers = [];

    User user = root.currentUser;

    slivers.addAll([
        new SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
            delegate: new SliverChildListDelegate(
              user.gallery.where( (p) {
                return !p.isClient && !p.wasProfile && !p.isProfile;
              }).map((p) {
              return new Padding(
                  child: new Image.asset(p.asset),
                  padding: const EdgeInsets.all(8.0));
            }).toList())),
    ]);

    return new Stack(
      children: [
        new CustomScrollView(slivers: slivers),
        const FabDialer(const [], Colors.blue, const Icon(Icons.add))
      ]
    );
  }
}
