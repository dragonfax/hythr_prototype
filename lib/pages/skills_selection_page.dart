import 'package:flutter/material.dart';
import 'tags_selection_page.dart';
import 'page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hythr/content/user.dart';

class Skill extends Tag {
  Skill(String name, ImageIcon icon, List<Tag> children)
      : super(name, icon, children, "skills");

  @override
  List<String> getTagList(User user) {
    return user.skills;
  }
}

List<Skill> skills = [
  new Skill("Women's Hair",
      new ImageIcon(new AssetImage("assets/icons/women.png")), null),
  new Skill("Men's Hair", new ImageIcon(new AssetImage("assets/icons/men.png")),
      null),
  new Skill(
      "Fine Hair", new ImageIcon(new AssetImage("assets/icons/thin_lines.png")), null),
  new Skill("Thick Hair", new ImageIcon(new AssetImage("assets/icons/thick_lines.png")),
      null),
  new Skill(
      "Wavy Hair", new ImageIcon(new AssetImage("assets/icons/wavy_lines.png")), null),
  new Skill("Curly Hair", new ImageIcon(new AssetImage("assets/icons/looped_line.png")),
      null),
  new Skill("Straight Hair",
      new ImageIcon(new AssetImage("assets/icons/straight_line.png")), null),
  new Skill("Asian Hair", new ImageIcon(new AssetImage("assets/icons/lotus.png")),
      null),
  new Skill("Afro Texture",
      new ImageIcon(new AssetImage("assets/icons/afro.png")), null),
  new Skill("Short Hair", new ImageIcon(new AssetImage("assets/icons/dashed_lines.png")),
      null),
  new Skill(
      "Long Hair", new ImageIcon(new AssetImage("assets/icons/long_lines.png")), null),
  new Skill(
      "Up Do's", new ImageIcon(new AssetImage("assets/icons/up_arrow.png")), null),
  new Skill("Wedding Hair",
      new ImageIcon(new AssetImage("assets/icons/wedding_ring.png")), null),
  new Skill(
      "Tint", new ImageIcon(new AssetImage("assets/icons/plusminus.png")), null),
  new Skill(
      "Highlight", new ImageIcon(new AssetImage("assets/icons/highlighter.png")), null),
  new Skill(
      "Balayage", new ImageIcon(new AssetImage("assets/icons/flame.png")), null),
  new Skill("Scissor Cut",
      new ImageIcon(new AssetImage("assets/icons/scissors.png")), null),
  new Skill(
      "Razor Cut", new ImageIcon(new AssetImage("assets/icons/razor.png")), null),
];

class SkillsSelectionPage {
  static void show(BuildContext context, User user) {
    new Page(
            title: "Stylist Skills",
            child: new TagsSelectionWidget(
                hint: "Select the skills you want to promote",
                user: user,
                tags: skills,
                document: FirebaseDatabase.instance.reference().child('users/' + user.googleId + '/skills')
            )
    ).show(context);
  }
}
