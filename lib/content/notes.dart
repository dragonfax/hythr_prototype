import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';


abstract class ClientNote {
  DateTime createdAt;

  Widget getWidget(BuildContext context);

  ClientNote();

  factory ClientNote.fromFirebaseSnapshot(DataSnapshot snapshot) {
    ClientNote n;
    if ( snapshot.value['type'] == "text" ) {
      n = new TextNote.fromFirebaseSnapshot(snapshot);
    } else if ( snapshot.value['type'] == "photo" ) {
      n = new PhotoNote.fromFirebaseSnapshot(snapshot);
    } else if ( snapshot.value['type'] == "timer" ) {
      n = new TimerNote.fromFirebaseSnapshot(snapshot);
    } else {
      throw "failed to get note type";
    }

    if (snapshot.value['created_at'] != null) {
      n.createdAt = new DateTime.fromMillisecondsSinceEpoch(snapshot.value['created_at']);
    }

    return n;
  }

  Map toFirebaseSet() {
    return {
      "created_at": createdAt == null ? ServerValue.timestamp : createdAt.millisecondsSinceEpoch
    };
  }


  String formatDate() {
    if ( createdAt != null ) {
      return createdAt.month.toString() + '/' + createdAt.day.toString();
    } else {
      return '';
    }
  }

  Widget getDateWidget() {
    return new Container(
      width: 50.0,
      child: new Text(formatDate())
    );
  }
}

class PhotoNote extends ClientNote {
  String photoUrl;

  PhotoNote(this.photoUrl);

  PhotoNote.fromFirebaseSnapshot(DataSnapshot snapshot) {
    photoUrl = snapshot.value['photo_url'];
  }

  @override
  toFirebaseSet() {
    var s = super.toFirebaseSet();
    s.addAll({ "type": "photo", "photo_url": photoUrl});
    return s;
  }

  @override
  getWidget(BuildContext context) {

    return new GestureDetector(
      onTap: () => show(context),
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Row(
          children: [
            getDateWidget(),
            new Icon(Icons.photo),
          ]
        )
      )
    );
  }

  show(context) {
    showDialog<Null>(
      context: context,
      child: new AlertDialog(
        content: new Image.network(photoUrl),
        actions: [
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Done")
          ),
        ]
      )
    );
  }
}

class TextNote extends ClientNote {

  String text;

  TextNote(this.text);

  TextNote.fromFirebaseSnapshot(DataSnapshot snapshot) {
    text = snapshot.value['text'];
  }

  @override
  toFirebaseSet() {
    var s = super.toFirebaseSet();
    s.addAll({ "type": "text", "text": text });
    return s;
  }

  @override
  getWidget(BuildContext context) {

    var sub = text;
    if (text.length > 20 ) {
      sub = text.substring(0,20);
    }

    return new GestureDetector(
      onTap: () => show(context),
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Row(
          children: [
            getDateWidget(),
            new Text(sub)
          ]
        )
      )
    );
  }

  show(context) {
    showDialog<Null>(
      context: context,
      child: new AlertDialog(
        content: new Text(text),
        actions: [
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Done")
          ),
        ]
      )
    );
  }
}

class TimerNote extends ClientNote {

  int timer;

  TimerNote(this.timer);

  TimerNote.fromFirebaseSnapshot(DataSnapshot snapshot) {
    timer = snapshot.value['timer'];
  }

  @override
  toFirebaseSet() {
    var s = super.toFirebaseSet();
    s.addAll({ "type": "timer", "timer": timer });
    return s;
  }

  @override
  getWidget(context) {

    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: [
          getDateWidget(),
          new Icon(Icons.timer),
          new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Text(timer.toString() + " minutes")
          )
        ]
      )
    );

  }

}
