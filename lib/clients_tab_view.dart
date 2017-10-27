import 'package:flutter/material.dart';
import 'content.dart';

class ClientsTabView extends StatelessWidget {
  ClientsTabView(this.clients);

  final List<HairClient> clients;

  Widget getTab() {
    return new Tab(
        text: 'Clients',
        icon: new Icon(Icons.people)
    );
  }

  @override
  Widget build(BuildContext context) {
    if ( clients.isEmpty ){
      return new Center( child: new Text('0 clients') );
    } else {
      return new ListView(
        itemExtent: 100.0,
        children: clients.map( (client) {
          return new ListTile(
            leading: new Image.asset(client.photo),
            title: new Text(client.realName)
          );
        }).toList()
      );
    }
  }
}
