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
import 'package:hythr/widgets/digit_dial.dart';
import 'package:hythr/content/notes.dart';


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

  createTimer(context) async {

    var d1 = new Digit();
    var d2 = new Digit();

    int result = await showDialog<int>(
      context: context,
      child: new AlertDialog(
        title: const Text("Create Timer"),
        content: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new DigitDial(d1),
            new DigitDial(d2),
            new Text("Min")
          ]
        ),
        actions: [new FlatButton(
          child: new Text("Start Timer"),
          onPressed: () {
            int value = d1.value * 10 + d2.value;
            Navigator.of(context).pop(value);
          }
        )]
      )
    );

    if ( result != null ) {
      clientNotesRef().push().set(new TimerNote(result).toFirebaseSet());
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
          child: new AddNoteContentMenu(
              addImageNote: addImageNote,
              addTextNote: addTextNote,
              createTimer: createTimer
          )
      )
    ]);
  }

}


class AddNoteContentMenu extends StatelessWidget {
  final ContextCallback addImageNote;
  final ContextCallback addTextNote;
  final ContextCallback createTimer;

  AddNoteContentMenu({ this.addImageNote, this.addTextNote, this.createTimer });

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
      new FabMiniMenuItem(
        textColor: Colors.white,
        chipColor: Colors.blue,
        fabColor: Colors.blue,
        icon: new Icon(Icons.timer),
        elevation: 4.0,
        text: "Start Timer",
        onPressed: () => createTimer(context)
      )
    ];

    return new FabDialer(fabList, Colors.blue, const Icon(Icons.add));
  }
}