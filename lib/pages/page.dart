import 'package:flutter/material.dart';
import 'package:hythr/widgets/yellow_divider.dart';
import 'package:flutter/foundation.dart';
import 'package:hythr/widgets/current_user.dart';
import 'package:hythr/widgets/current_user_data.dart';
import 'timers_list_page.dart';

class Page extends StatelessWidget {
  final String title;
  final Widget child;

  Page({ @required this.title, @required this.child });

  show(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new UserChangedWatcher(child: new UserDataChangedWatcher(child: this));
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
          actions: <Widget>[ new TimerListButton() ]
        ),
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