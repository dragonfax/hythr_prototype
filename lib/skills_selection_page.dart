import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'content.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'dart:ui' as ui show Image;



class Skill {
  String name;
  IconData icon;

  Skill(this.name, this.icon);

  bool getValue(User user) {
    return user.skills.contains(name);
  }

  toggle(User user) {
    if ( user.skills.contains(name) ) {
      user.skills.remove(name);
    } else {
      user.skills.add(name);
    }
  }
}

List<Skill> skills = [
  new Skill("Women's Hair", Icons.pregnant_woman),
  new Skill("Men's Hair", Icons.local_post_office),
  new Skill("Fine Hair", Icons.donut_small),
  new Skill("Thick Hair", Icons.donut_large),
  new Skill("Wavy Hair", Icons.lens),
  new Skill("Curly Hair", Icons.stay_current_landscape),
  new Skill("Straigh Hair", Icons.straighten),
  new Skill("Asian Hair", Icons.assignment_ind),
  new Skill("Afro Texture", Icons.accessible_forward),
  new Skill("Short Hair", Icons.short_text),
  new Skill("Long Hair", Icons.location_on),
  new Skill("Up Do's", Icons.update),
  new Skill("Wedding Hair", Icons.web),
  new Skill("Tint", Icons.turned_in),
  new Skill("Highlight", Icons.highlight),
  new Skill("Balayage", Icons.account_balance),
  new Skill("Scissor Cut", Icons.supervised_user_circle),
  new Skill("Razor Cut", Icons.radio)
];

class SkillsSelectionPage {

  static activate(BuildContext context, User user, SetStateCallback stateCallback) {
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(title: new Text("Stylist Skills")),
            body: new SkillsSelectionWidget(user, stateCallback)
          );
        }
      )
    );
  }
}

typedef void SetStateCallback();

class SkillsSelectionWidget extends StatefulWidget {

  final User user;
  final SetStateCallback stateCallback;

  SkillsSelectionWidget(this.user, this.stateCallback);

  @override
  createState() => new SkillsSelectionWidgetState(user, stateCallback);

}

class SkillsSelectionWidgetState extends State<SkillsSelectionWidget> {

  final User user;
  final SetStateCallback stateCallback;

  SkillsSelectionWidgetState(this.user, this.stateCallback);

  Widget build(BuildContext context) {
    return new GridView.count(
              crossAxisCount: 2,
              children: skills.map((skill){
                return new Switch(
                  value: skill.getValue(user),
                  onChanged: (bool newValue) {
                    setState((){
                      skill.toggle(user);
                    });
                    stateCallback();
                  },
                );
              }).toList()
            );
  }
}