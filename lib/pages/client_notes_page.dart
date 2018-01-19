import 'package:flutter/material.dart';
import 'package:hythr/content/client.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/widgets.dart';
import 'page.dart';
import 'package:hythr/content/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'input_dialog.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:hythr/constants.dart';


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

  clientRef() {
    return FirebaseDatabase.instance.reference().child(
        "/clients/" + user.googleId + '/' + client.key);
  }

  Widget onTapGesture(Widget child, callback) {
    return new GestureDetector(
      onTap: callback,
      child: child,
    );
  }

  editClientName(BuildContext context) async {
    var name = await new InputDialog(
        title: "Enter Client Name",
        actionLabel: "Change Client Name"
    ).show(context);

    if ( name != null && name != "" ) {
      await clientRef().update({ "name": name});
    }
  }

  editClientPhoto(BuildContext context) async {
    File imageFile = await ImagePicker.pickImage();

    if (imageFile == null ) {
      return;
    }

    int random = new Random().nextInt(100000);
    StorageReference sref = FirebaseStorage.instance.ref().child("${user.googleId}_client-profile_${client.key}_$random.jpg");
    StorageUploadTask uploadTask = sref.put(imageFile);
    Uri imageUrl = (await uploadTask.future).downloadUrl;

    clientRef().update({ "photo_url": imageUrl.toString() });
  }

  addImageNote(context) async {
    File imageFile = await ImagePicker.pickImage();

    int random = new Random().nextInt(100000);
    StorageReference sref = FirebaseStorage.instance.ref().child("${user.googleId}_client_${client.key}_$random.jpg");
    StorageUploadTask uploadTask = sref.put(imageFile);
    Uri imageUrl = (await uploadTask.future).downloadUrl;

    clientNotesRef().push().set(new PhotoNote(imageUrl.toString()).toFirebaseSet());
  }

  addTextNote(context) async {
    String text = await new InputDialog(
        title: "Enter Text Note",
        labelText: "Type Here",
        actionLabel: "Finished"
    ).show(context);

    if ( text != null ) {
      clientNotesRef().push().set(new TextNote(text).toFirebaseSet());
    }
  }

  @override
  build(context) {
    // var controller = new TextEditingController();

    return
    new Stack(children: [
      new Column(children: [
        new ListTile(
          leading: onTapGesture(client.getChip(), () => editClientPhoto(context) ),
          title: onTapGesture(new Text(client.name), () => editClientName(context)),
        ),
        new FlatButton( child: new Text("Send Message"), onPressed: () {
          new InputDialog(title: "Message Client", actionLabel: "Enter a message").show(context);
        } ),
        /*new TextField(
          controller: controller,
          decoration: new InputDecoration( labelText: "Enter a note"),
          onSubmitted: (t) {
            clientNotesRef().push().set(new TextNote(t).toFirebaseSet());
            controller.clear();
          }
        ), */
        new Expanded(child: new FirebaseAnimatedList(
            sort: (a, b) => b.key.compareTo(a.key),
            query: clientNotesRef(),
            itemBuilder: (context, snapshot, animation, index) {
              ClientNote note = new ClientNote.fromFirebaseSnapshot(snapshot);
              return new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new Divider(),
                    note.getWidget(context),
                  ]
              );
            }
          )
        )
      ]),
      new Positioned(
          right: 10.0,
          bottom:10.0,
          child: new AddNoteContentMenu(addImageNote: addImageNote, addTextNote: addTextNote)
      )
    ]);
  }

}


class AddNoteContentMenu extends StatelessWidget {
  final ContextCallback addImageNote;
  final ContextCallback addTextNote;

  AddNoteContentMenu({ this.addImageNote, this.addTextNote });

  @override
  build(context) {

    final List<FabMiniMenuItem> fabList = [
      new FabMiniMenuItem(
        textColor: Colors.white,
        chipColor: Colors.blue,
        fabColor: Colors.blue,
        icon: new Icon(Icons.camera),
        elevation: 4.0,
        text: "Add Photo",
        tooltip: "Take a Photo",
        onPressed: () => addImageNote(context)
      ),
      new FabMiniMenuItem(
          textColor: Colors.white,
          chipColor: Colors.blue,
          fabColor: Colors.blue,
          icon: new Icon(Icons.short_text),
          elevation: 4.0,
          text: "Add Note",
          tooltip: "Add a Text Note",
          onPressed: () => addTextNote(context)
      ),
    ];

    return new FabDialer(fabList, Colors.blue, const Icon(Icons.add));
  }
}