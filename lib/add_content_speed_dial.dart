import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';

class ContentType {
  String title;
  String toolTip;

  ContentType(this.title, this.toolTip);
}

final List<ContentType> types = [
  new ContentType("Profile Photo","Take a new Profile Picture"),
  new ContentType("Client Note", "Add a note about a client"),
  new ContentType("Client Photo", "Take a photo of a client"),
  new ContentType("Add to Portfolio", "Add a picture the your Personal Portfolio"),
  new ContentType("Add Inspiration", "Add a picture to your Inspiration gallery")
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
