import 'package:flutter/material.dart';
import 'package:hythr/content/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          backgroundImage: new CachedNetworkImageProvider( photoUrl )
      );
    } else {
      return new CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          child: new Text(getInitials(name))
      );
    }
  }

}

