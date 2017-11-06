import 'package:flutter/material.dart';
import 'content.dart';

import 'package:flutter/foundation.dart';


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
    return new Column(
      children: [
        new Padding(
            padding: new EdgeInsets.symmetric(vertical: 8.0),
            child: new Text("Select skill you want to promote.", style: new TextStyle(fontStyle: FontStyle.italic))
        ),
        new Expanded(
          child: new GridView.count(
            crossAxisCount: 2,
            // shrinkWrap: true,
            childAspectRatio: 2.0,
            children: skills.map((skill){
              return new SkillSwitch(
                user: user,
                skill: skill,
                onChanged: stateCallback == null ? null :  (SetStateCallback block) {
                  setState((){
                    block();
                    stateCallback();
                  });
                }
              );
            }).toList()
          ))
      ]
    );
  }
}

typedef void OnChangeCallback(SetStateCallback f);

class SkillSwitch extends StatelessWidget {

  final User user;
  final Skill skill;
  final OnChangeCallback onChanged;

  const SkillSwitch({ @required this.user, @required this.skill, @required this.onChanged });

  @override
  Widget build(BuildContext context) {
    return new ToggleButton(
      onChanged: onChanged == null ? null : () { onChanged(() { skill.toggle(user); }); },
      value: skill.getValue(user),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          new Icon(skill.icon),
          new Text(skill.name)
        ]
      )
    );
  }
}

/* toggle doesn't track its own state, or change any state when clicked.
   it relies ont he parent to do that and give it its new state (value)

   Its only useful for alternating between on/off colors. on behalf o the parent.
 */
class ToggleButton extends StatelessWidget {

  final Widget child;
  final bool value;
  final SetStateCallback onChanged;
  final Color onColor;
  final Color offColor;

  ToggleButton({
    @required this.child,
    @required this.value,
    @required this.onChanged,
    this.onColor = Colors.yellow,
    this.offColor = Colors.grey,
  });

  Widget build(BuildContext context) {
    return new DefaultTextStyle(
      style: new TextStyle( color: value ? onColor : offColor ),
      child: new IconTheme(
        data: new IconThemeData(
          color: value ? onColor : offColor
        ),
        child: new InkWell(
          child: new Center( child: child),
          onTap: onChanged == null ? null : onChanged
        )
      )
    );
  }

}
