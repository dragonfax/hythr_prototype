import 'package:flutter/material.dart';
import 'content.dart' as content;


class NotificationsTabView extends StatelessWidget {
  NotificationsTabView(this.notifications);

  final List<content.Notification> notifications;

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

