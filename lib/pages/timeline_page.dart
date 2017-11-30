import 'package:flutter/material.dart';
import '../content/content.dart';
import 'package:hythr/pages/page.dart';

class TimeLinePage extends StatelessWidget {
  static show(BuildContext context) {
    new Page(title: "TimeLine", child: new TimeLinePage()).show(context);
  }

  Widget build(BuildContext context) {

    return new CustomScrollView(
        slivers: [
          new SliverList(
              delegate: new SliverChildListDelegate(
                root.timeline.map((t) { return t.getWidget(); }).toList()
              )
          )
        ]
    );
  }

}
