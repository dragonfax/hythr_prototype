import 'package:flutter/material.dart';
import 'content.dart';
import 'profile_widget.dart';

class ClientsTabView extends StatelessWidget {
  ClientsTabView(this.clients, this.skills);

  final List<User> clients;
  final List<Skill> skills;

  Widget getTab() {
    return new Tab(
        text: 'Clients',
        icon: new Icon(Icons.people)
    );
  }

  @override
  Widget build(BuildContext context) {
    if ( clients == null || clients.isEmpty ){
      return new Center( child: new Text('0 clients') );
    } else {
      return new ListView(
        itemExtent: 100.0,
        children: clients.map( (client) {
          return new ListTile(
            leading: client.getProfilePicture(),
            title: new Text(client.realName),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) {
                  return new Scaffold(
                      appBar: new AppBar(title: new Text(client.realName)),
                      body: new ProfileWidget(client, false, skills)
                  );
                },
              ));
            },
          );
        }).toList()
      );
    }
  }
}
