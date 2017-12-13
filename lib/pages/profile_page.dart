import 'dart:math';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'page.dart';
import 'interests_selection_page.dart';
import 'skills_selection_page.dart';
import 'input_dialog.dart';
import 'package:hythr/content/user.dart';


class ProfilePage extends StatelessWidget {
  final bool canEdit;
  final User user;
  final bool asClient; // otherwise as-stylist

  ProfilePage(
      {@required this.user, this.canEdit = false, this.asClient = false});

  static show(BuildContext context, User user, bool canEdit, bool asClient) {
    new Page(
            title: "Stylist Profile",
            child: new ProfilePage(
                user: user, canEdit: canEdit, asClient: asClient))
        .show(context);
  }

  pickProfilePicture() async {
    File imageFile = await ImagePicker.pickImage();

    int random = new Random().nextInt(100000);
    StorageReference sref = FirebaseStorage.instance.ref().child("${user.googleId}_profile_$random.jpg");
    StorageUploadTask uploadTask = sref.put(imageFile);
    Uri imageUrl = (await uploadTask.future).downloadUrl;

    user.firebaseRef().child("photo_url").set(imageUrl.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("users/" + user.googleId)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> asyncEvent) {
          if (asyncEvent?.data?.snapshot?.value == null) {
            return new Text("Loading...");
          }

          User user = new User.fromFirebaseSnapshot(asyncEvent?.data?.snapshot);

          // initial tiles with basic user info for the first sliver.
          List<Widget> basicInfo = [
            new ListTile(
                leading: new GestureDetector(
                    child: user.getChip(),
                    onTap: pickProfilePicture
                ),
                title: new Text(user.realName ?? "<unknown>"),
                subtitle: new Column(children: [
                  new Text(user.email),
                ]),
                onTap: () async {
                  var realName = await new InputDialog(
                          title: 'Enter Your Name',
                          labelText: 'Full Name',
                          initial: user.realName)
                      .show(context);

                  if (realName != null) {
                    user.firebaseRef().child("real_name").set(realName);
                  }
                }),
          ];

          if (!asClient) {
            basicInfo.addAll([
              const Divider(),
              new ListTile(
                  leading: const Text("Bio"),
                  title: new Text(user.bio ?? "None"),
                  onTap: () async {
                    var bio = await new InputDialog(
                      title: "Biography",
                      labelText: "Bio",
                      initial: user.bio,
                      actionLabel: "No Regrets!",
                    ).show(context);

                    if (bio != null ) {
                      user.firebaseRef().child("bio").set(bio);
                    }
                  }),
            ]);
          }

          basicInfo.addAll([
            const Divider(),
            new ListTile(
              leading: const Icon(Icons.phone),
              title: new Text(user.phone ?? "XXX-XXX-XXXX"),
              onTap: () async {
                var phone = await new InputDialog(
                  title: "Your Phone Number",
                  initial: user.phone
                ).show(context);

                if ( phone != null ) {
                  user.firebaseRef().child("phone").set(phone);
                }
              }
            ),
            const Divider(),
            new ListTile(
                leading: const Icon(Icons.message),
                title: new Text("Send message"),
                onTap: () {
                  ContactClientButton.showContactDialog(context);
                }),
            const Divider(),
          ]);

          if (!asClient && user.salon != null) {
            basicInfo.addAll([
              new ListTile(
                leading: new Column(children: const [
                  const Icon(Icons.content_cut),
                ]),
                title: new Text(user.salon.name ?? ""),
                subtitle: new Text(user.salon.address +
                    "\n" +
                    user.salon.hours +
                    "\n" +
                    user.salon.phone),
              ),
              const Divider()
            ]);
          }

          basicInfo.addAll([
            new ListTile(
                leading: const Icon(Icons.book),
                title: const Text("Interests"),
                subtitle: new Text(user.interests.join(", ")),
                onTap: !canEdit
                    ? null
                    : () {
                        InterestsSelectionPage.show(context, user);
                      }),
            new ListTile(
                leading: const Icon(Icons.merge_type),
                title: const Text("Your Hair Type")),
          ]);

          if (!asClient) {
            basicInfo.addAll([
              new Divider(),
              new ListTile(
                  leading: const Icon(Icons.content_cut),
                  title: const Text("Skills"),
                  subtitle: new Text(user.skills.join(", ")),
                  onTap: !canEdit
                      ? null
                      : () {
                          SkillsSelectionPage.show(context, user);
                        }),
            ]);
          }

          if (!asClient) {
            basicInfo.addAll([
              const Divider(),
              new ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text("Certifications"),
                  subtitle: new Text((user.certifications ?? []).join(", "))),
            ]);
          }

          basicInfo.addAll([
            const Divider(),
            new ListTile(
              leading: const Icon(Icons.person_outline),
              title: new Text("Personal photos"),
            ),
            const Divider(),
            new ListTile(
                leading: const Icon(Icons.star),
                title: new Text("Inspiration photos")),
          ]);

          if (asClient) {
            basicInfo.addAll(const [
              const Divider(),
              const ListTile(
                  leading: const Icon(Icons.note),
                  title: const Text("Your Notes & Photos")),
            ]);
          }

          SliverList slist =
              new SliverList(delegate: new SliverChildListDelegate(basicInfo));

          return new CustomScrollView(slivers: [slist]);
        });
  }
}

class ContactClientButton {
  static showContactDialog(BuildContext context) async {
    showDialog<Null>(
        context: context,
        child: new AlertDialog(
            title: const Text('Contact Client'),
            content: const TextField(),
            actions: [
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Send"))
            ]));
  }
}
