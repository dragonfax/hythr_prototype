import 'package:flutter/material.dart';
import 'content.dart';

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
  new Skill("Men's Hair", Icons.pregnant_woman),
  new Skill("Fine Hair", Icons.pregnant_woman),
  new Skill("Thick Hair", Icons.pregnant_woman),
  new Skill("Wavy Hair", Icons.pregnant_woman),
  new Skill("Curly Hair", Icons.pregnant_woman),
  new Skill("Straigh Hair", Icons.pregnant_woman),
  new Skill("Asian Hair", Icons.pregnant_woman),
  new Skill("Afro Texture", Icons.pregnant_woman),
  new Skill("Short Hair", Icons.pregnant_woman),
  new Skill("Long Hair", Icons.pregnant_woman),
  new Skill("Up Do's", Icons.pregnant_woman),
  new Skill("Wedding Hair", Icons.pregnant_woman),
  new Skill("Tint", Icons.pregnant_woman),
  new Skill("Highlight", Icons.pregnant_woman),
  new Skill("Balayage", Icons.pregnant_woman),
  new Skill("Scissor Cut", Icons.pregnant_woman),
  new Skill("Razor Cut", Icons.pregnant_woman)
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