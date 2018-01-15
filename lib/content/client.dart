import 'package:flutter/material.dart';
import 'package:hythr/content/user.dart';

// Virtual Client
//   used just for taking notes. not a real User.
class Client {
  String key;
  String name;
  String photoUrl;

  Client.fromFirebaseSnapshot(String k, Map value) {
    key = k;
    name = value['name'];
    photoUrl = value['photo_url'];
  }

  Widget getChip() {
    if ( photoUrl != null ) {
      return new CircleAvatar(
          backgroundImage: new NetworkImage( photoUrl )
      );
    } else {
      return new CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          child: new Text(getInitials(name.toUpperCase()))
      );
    }
  }

}

