import 'package:flutter/material.dart';
import 'yellow_divider.dart';
import 'package:flutter/foundation.dart';

class Page extends StatelessWidget {
  final String title;
  final Widget child;

  Page({ @required this.title, @required this.child });

  show(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return this;
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(title)),
        body: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const YellowDivider(),
              new Expanded(
                  child: child
              )
            ]
        )
    );

  }

}