import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

abstract class ClientNote {

  Widget getWidget();

  static ClientNote fromJson(Map json) {
    if ( json['type'] == 'text' ) {
      return new TextNote.fromJson(json);
    } else if ( json['type'] == 'photo' ) {
      return new PhotoNote.fromJson(json);
    } else {
      throw "unknown client note type ${json['type']}";
    }
  }

  static Map<String,List<ClientNote>> fromJsonMap(Map json) {
    if ( json == null ) {
      return new Map();
    }

    Map<String,List<ClientNote>> notes = new Map();

    json.forEach((client, noteList) {
      List<ClientNote> l = new List();
      notes[client] = l;
      noteList.forEach((note) {
        l.add(ClientNote.fromJson(note));
      });
    });

    return notes;
  }
}

class TextNote extends ClientNote {

  String text;

  @override
  Widget getWidget() {
    return new ListTile(
      title: new Text(text)
    );
  }

  TextNote.fromJson(Map json) {
    text = json['text'];
  }
}

class PhotoNote extends ClientNote {

  String asset;

  Widget getWidget() {
    return new Image.asset(asset);
  }

  PhotoNote.fromJson(Map json) {
    asset = json['asset'];
  }
}