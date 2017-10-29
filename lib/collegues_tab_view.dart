import 'package:flutter/material.dart';
import 'content.dart';

class ColleguesTabView extends StatelessWidget {

  final List<Stylist> stylists;

  ColleguesTabView(this.stylists);

  Widget getTab() {
    return new Tab(
      text: 'Stylists',
      icon: new Icon(Icons.group_work)
    );
  }

  @override
  Widget build(BuildContext context) {
    if ( stylists == null || stylists.isEmpty ) {
      return new Center( child: new Text('0 connected collegues') ) ;
    } else {
      return new ListView(
          itemExtent: 100.0,
          children: stylists.map((stylist) {
            return new ListTile(
                leading: stylist.getProfilePicture(),
                title: new Text(stylist.realName)
            );
          }).toList()
      );
    }
  }
}
