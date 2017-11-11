import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'content/user.dart';
import 'content/tag.dart';
import 'toggle_button.dart';
import 'page.dart';

const List<Color> blacks = const [
  const Color(0xFF202020),
  const Color(0xFF161616),
  const Color(0xFF121212),
  const Color(0xFF101010),
  const Color(0xFF080808),
  const Color(0xFF060606),
  const Color(0xFF080808),
  const Color(0xFF101010),
  const Color(0xFF121212),
  const Color(0xFF161616),
];

class TagSwitch extends ToggleButton {

  final User user;
  final Tag tag;
  final VoidCallback onChanged;
  final VoidCallback onLongPress;
  final Color bgColor;

  TagSwitch({
    @required this.user,
    @required this.tag,
    @required this.onChanged,
    this.onLongPress,
    this.bgColor = Colors.black
  }) : super(
    name: tag.name,
    icon: tag.icon,
    value: tag.getValue(user),
    onChanged: onChanged == null ? null :  onChanged,
    onLongPress: onLongPress,
    bgColor: bgColor,
  );
}

class TagsSelectionWidget extends StatefulWidget {
  final String hint;
  final User user;
  final bool canEdit;
  final List<Tag> tags;

  const TagsSelectionWidget({ @required this.hint, @required this.user, this.canEdit = true, @required this.tags });

  @override
  createState() => new TagsSelectionWidgetState(hint: hint, user: user, tags: tags);
}

class TagsSelectionWidgetState extends State<TagsSelectionWidget> {
  final String hint;

  final User user;
  final bool canEdit;
  final List<Tag> tags;

  TagsSelectionWidgetState({ @required this.hint, @required this.user, this.canEdit =true, @required this.tags });

  List<Widget> buildToggles(BuildContext context) {

    int index = 0;
    return tags.map((tag){
      index++;
      return new TagSwitch(
          user: user,
          tag: tag,
          bgColor: blacks[index % blacks.length],
          onChanged: ! canEdit ? null : () {
            setState((){
              tag.toggle(user);
            });
          },
          onLongPress: ! tag.hasChildren() ? null : () {
            InterestsSelectionPage.show(context,user,tag.children);
          },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return new DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.black
      ),
      child: new Column(
        children: [
          new Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: new Text(hint, style: const TextStyle(fontStyle: FontStyle.italic))
          ),
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              children: buildToggles(context)
            )
          )
        ]
      )
    );
  }
}


class SkillsSelectionPage {
  static void show(BuildContext context, User user, List<Tag> tags) {
    new Page(
        title: "Stylist Skills",
        child: new TagsSelectionWidget(
            hint: "Select the skills you want to promote",
            user: user,
            tags: tags)
    ).show(context);
  }
}


class InterestsSelectionPage {

  static void show(BuildContext context, User user, List<Tag> tags) {
    new Page(
      title: "Interests & Hobbies",
      child: new TagsSelectionWidget(
        hint: "Select interests that you want to share",
        user: user,
        tags: tags
      )
    ).show(context);
  }
}


