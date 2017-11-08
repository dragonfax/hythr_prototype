import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'content.dart';
import 'toggle_button.dart';


class SkillSwitch extends ToggleButton {

  final User user;
  final Skill skill;
  final VoidCallback onChanged;
  final Color bgColor;

  SkillSwitch({
    @required this.user,
    @required this.skill,
    @required this.onChanged,
    this.bgColor = Colors.black
  }) : super(
    name: skill.name,
    icon: skill.icon,
    value: skill.getValue(user),
    onChanged: onChanged == null ? null :  onChanged,
    bgColor: bgColor,
  );
}

class SkillsSelectionWidget extends ToggleSelectionWidget {
  final User user;
  final bool canEdit;
  final List<Skill> skills;

  SkillsSelectionWidget(this.user, this.canEdit, this.skills);

  @override
  createState() => new SkillsSelectionWidgetState(user, canEdit, skills);
}

class SkillsSelectionWidgetState extends ToggleSelectionWidgetState {
  final User user;
  final bool canEdit;
  final List<Skill> skills;

  SkillsSelectionWidgetState(this.user,this.canEdit, this.skills);

  @override
  List<Widget> buildToggles() {

    int index = 0;
    return skills.map((skill){
      index++;
      return new SkillSwitch(
          user: user,
          skill: skill,
          bgColor: blacks[index % blacks.length],
          onChanged: ! canEdit ? null : () {
            setState((){
              skill.toggle(user);
            });
          }
      );
    }).toList();
  }
}

class SkillsSelectionPage {

  static void show(BuildContext context, User user, bool canEdit, List<Skill> skills) {
    ToggleSelectionPage.show(
      context,
      "Stylist Skills",
      canEdit ? "Select the skills you want to promote" : "Skills",
      (context) {
        return new SkillsSelectionWidget(user, canEdit, skills);
      }
    );
  }
}
