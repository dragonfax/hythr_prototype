import 'package:flutter/material.dart';
import 'content.dart';
import 'profile_widget.dart';

class StylistsTabView extends StatelessWidget {

  final List<User> stylists;

  StylistsTabView(this.stylists);

  Widget getTab() {
    return new Tab(
      text: 'Stylists',
      icon: new Icon(Icons.group_work)
    );
  }

  @override
  Widget build(BuildContext context) {
    if ( stylists == null || stylists.isEmpty ) {
      return new Center( child: new Text('0 stylists followed') ) ;
    } else {
      return new ListView(
          itemExtent: 100.0,
          children: stylists.map((stylist) {
            return new ListTile(
                leading: stylist.getProfilePicture(),
                title: new Text(stylist.realName),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return new Scaffold(
                        appBar: new AppBar(title: new Text(stylist.realName)),
                        body: new ProfileWidget(stylist, false)
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
