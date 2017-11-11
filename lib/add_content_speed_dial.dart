import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';

class ContentType {
  final String title;
  final String toolTip;

  const ContentType(this.title, this.toolTip);
}

const List<ContentType> types = const [
  const ContentType("Profile Photo","Take a new Profile Picture"),
  const ContentType("Client Note", "Add a note about a client"),
  const ContentType("Client Photo", "Take a photo of a client"),
  const ContentType("Add to Portfolio", "Add a picture the your Personal Portfolio"),
  const ContentType("Add Inspiration", "Add a picture to your Inspiration gallery")
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

    return new FabDialer(fabList, Colors.blue, const Icon(Icons.add));
  }
}
