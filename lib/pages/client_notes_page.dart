import 'package:flutter/material.dart';
import 'package:hythr/content/client.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'page.dart';
import 'package:hythr/content/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:hythr/content/content.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class ClientNote {
  Widget getWidget();

  ClientNote();

  factory ClientNote.fromFirebaseSnapshot(DataSnapshot snapshot) {
    if ( snapshot.value['type'] == "text" ) {
      return new TextNote.fromFirebaseSnapshot(snapshot);
    } else if ( snapshot.value['type'] == "photo" ) {
      return new PhotoNote.fromFirebaseSnapshot(snapshot);
    } else {
      throw "failed to get note type";
    }
  }
}

class PhotoNote extends ClientNote {
  String photoUrl;

  PhotoNote(this.photoUrl);

  PhotoNote.fromFirebaseSnapshot(DataSnapshot snapshot) {
    photoUrl = snapshot.value['photo_url'];
  }

  toFirebaseSet() {
    return { "type": "photo", "photo_url": photoUrl };
  }

  @override
  getWidget() {
    return new Image.network(photoUrl);
  }
}

class TextNote extends ClientNote {

  String text;

  TextNote(this.text);

  TextNote.fromFirebaseSnapshot(DataSnapshot snapshot) {
    text = snapshot.value['text'];
  }

  toFirebaseSet() {
    return { "type": "text", "text": text };
  }

  @override
  getWidget() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Text(text) );
  }

}

class ClientNotesPage extends StatelessWidget {

  final User user;
  final Client client;

  ClientNotesPage(this.user, this.client);

  show(BuildContext context) {
    new Page(title: "Notes: " + client.name, child: this).show(context);
  }

  clientNotesRef() {
    return FirebaseDatabase.instance.reference().child(
        "/notes/" + user.googleId + '/' + client.key);
  }

  @override
  build(context) {
    var controller = new TextEditingController();


    return
    new Stack(children: [
      new Column(children: [
        new TextField(
          controller: controller,
          decoration: new InputDecoration( labelText: "Enter a note"),
          onSubmitted: (t) {
            clientNotesRef().push().set(new TextNote(t).toFirebaseSet());
            controller.clear();
          }
        ),
        new Expanded(child: new FirebaseAnimatedList(
            reverse: true,
            sort: (a, b) => b.key.compareTo(a.key),
            query: clientNotesRef(),
            itemBuilder: (context, snapshot, animation, index) {
              ClientNote note = new ClientNote.fromFirebaseSnapshot(snapshot);
              return note.getWidget();
            }
          )
        )
      ]),
      new Positioned(
          right: 10.0,
          bottom:10.0,
          child:
            new FloatingActionButton(
              child: new Icon(Icons.camera),
              tooltip: "Take a Photo",
              onPressed: () async {

                File imageFile = await ImagePicker.pickImage();

                int random = new Random().nextInt(100000);
                StorageReference sref = FirebaseStorage.instance.ref().child("${user.googleId}_client_${client.key}_$random.jpg");
                StorageUploadTask uploadTask = sref.put(imageFile);
                Uri imageUrl = (await uploadTask.future).downloadUrl;

                clientNotesRef().push().set(new PhotoNote(imageUrl.toString()).toFirebaseSet());
              }
            )
      )
    ]);
  }

}