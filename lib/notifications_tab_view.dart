import 'package:flutter/material.dart';
import 'content/notification.dart' as content;
import 'content/root.dart';

class NotificationsTabView extends StatelessWidget {
  NotificationsTabView(this.notifications);

  final List<content.Notification> notifications;

  static show(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Scaffold(
              appBar: new AppBar(
                  title: new Text("Notifications"),
                  actions: [
                    new IconButton(
                        icon: new Icon(
                            Icons.notifications, color: Colors.white),
                        tooltip: "Notifications",
                        onPressed: () {
                          Navigator.of(context).pop();
                        }
                    )
                  ]
              ),
              body: new NotificationsTabView(root.currentUser?.notifications)
          );
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    if ( notifications == null || notifications.isEmpty ) {
      return new Center( child: new Text('0 notifications')) ;
    } else {
      return new ListView(
        itemExtent: 100.0,
        children: notifications.map((notification) {
          return notification.buildListTile();
        }).toList()
      );
    }
  }
}

