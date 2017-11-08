import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'content.dart';
import 'toggle_button.dart';
import 'set_state_callback.dart';

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

class SkillSwitch extends StatelessWidget {

  final User user;
  final Skill skill;
  final VoidCallback onChanged;
  final Color bgColor;

  const SkillSwitch({
    @required this.user,
    @required this.skill,
    @required this.onChanged,
    this.bgColor = Colors.black
  });

  @override
  Widget build(BuildContext context) {
    return new ToggleButton(
      name: skill.name,
      icon: skill.icon,
      value: skill.getValue(user),
      onChanged: onChanged == null ? null :  onChanged,
      bgColor: bgColor,
    );
  }
}

class SkillsSelectionPage extends ToggleSelectionPage {
  final User user;
  final SetStateCallback userChangingCallback;

  SkillsSelectionPage(this.user, this.userChangingCallback) : super("Stylist Skills", "Select the skills you want to promote");

  @override
  List<Widget> buildToggles(SetStateCallback localUserChangingCallback) {

    int index = 0;
    return skills.map((skill){
      index++;
      return new SkillSwitch(
          user: user,
          skill: skill,
          bgColor: blacks[index % blacks.length],
          onChanged: userChangingCallback == null ? null :  () {
            userChangingCallback((){
              localUserChangingCallback((){
                skill.toggle(user);
              });
            });
          }
      );
    }).toList();
  }
}
