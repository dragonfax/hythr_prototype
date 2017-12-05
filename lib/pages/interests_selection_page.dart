import '../content/content.dart';
import 'tags_selection_page.dart';
import 'package:flutter/material.dart';
import 'page.dart';
import 'package:firebase_database/firebase_database.dart';

class Interest extends Tag {

  Interest(String name, ImageIcon icon, List<Tag> children) : super(name, icon, children, "interests");

  @override
  List<String> getTagList(User user) {
    return user.interests;
  }
}

List<Interest> interests = [
  new Interest(
    "Sports",
    new ImageIcon(new AssetImage("assets/icons/gradient.png")),
    <Tag>[
      new Interest(
        "Hockey",
        new ImageIcon(new AssetImage("assets/icons/gradient.png")),
        null
      ),
      new Interest(
        "Baseball",
        new ImageIcon(new AssetImage("assets/icons/gradient.png")),
        null
      ),
    ]
  ),
  new Interest(
    "News",
    new ImageIcon(new AssetImage("assets/icons/gradient.png")),
    null
  ),
];

class InterestsSelectionPage {

  static void show(BuildContext context, User user) {
    new Page(
      title: "Interests & Hobbies",
      child: new TagsSelectionWidget(
        hint: "Select interests that you want to share",
        user: user,
        tags: interests,
        document: FirebaseDatabase.instance.reference().child('users/' + user.googleId + '/interests')
      )
    ).show(context);
  }
}

