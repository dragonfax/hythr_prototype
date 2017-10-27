import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';

class ContentType {
  String title;
  String toolTip;

  ContentType(this.title, this.toolTip);
}

final List<ContentType> types = [
  new ContentType("Photo","Take a new Profile Picture"),
  new ContentType("Gallery", "Add a new image to your Gallery"),
  new ContentType("Log", "Add a note to your Clients Log"),
  new ContentType("Story", "Add a new video to your Gallery"),
  new ContentType("Schedule", "Schedule an appointment with a Client")
];

class AddContentSpeedDial extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final List<FabMiniMenuItem> fabList = types.map((t) {
      return new FabMiniMenuItem(
        textColor: Colors.white,
        chipColor: Colors.blue,
        fabColor: Colors.blue,
        icon: new Icon(Icons.add),
        elevation: 4.0,
        text: t.title,
        tooltip: t.toolTip
      );
    }).toList();

    return new FabDialer(fabList, Colors.blue, new Icon(Icons.add));
  }
}
