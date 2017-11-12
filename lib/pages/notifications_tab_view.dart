import 'package:flutter/material.dart';
import '../content/content.dart' as content;
import 'package:hythr/pages/page.dart';

class NotificationsTabView extends StatelessWidget {
  NotificationsTabView(this.notifications);

  final List<content.Notification> notifications;

  static show(BuildContext context) {
    new Page( title: "Notifications", child: new NotificationsTabView(content.root.currentUser?.notifications) ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    if ( notifications == null || notifications.isEmpty ) {
      return const Center( child: const Text('0 notifications')) ;
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

