import 'package:flutter/material.dart';
import 'content.dart';

class ColleguesTabView extends StatelessWidget {

  final List<Stylist> stylists;

  ColleguesTabView(this.stylists);

  @override
  Widget build(BuildContext context) {
    if ( stylists.isEmpty ) {
      return new Center( child: new Text('0 connected collegues') ) ;
    } else {
      return new ListView(
          itemExtent: 100.0,
          children: stylists.map((stylist) {
            return new ListTile(
                leading: new Image.asset(stylist.photo, fit: BoxFit.fitHeight),
                title: new Text(stylist.realName)
            );
          }).toList()
      );
    }
  }
}