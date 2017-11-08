import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'content.dart';
import 'toggle_button.dart';


class TagSwitch extends ToggleButton {

  final User user;
  final Tag tag;
  final VoidCallback onChanged;
  final Color bgColor;

  TagSwitch({
    @required this.user,
    @required this.tag,
    @required this.onChanged,
    this.bgColor = Colors.black
  }) : super(
    name: tag.name,
    icon: tag.icon,
    value: tag.getValue(user),
    onChanged: onChanged == null ? null :  onChanged,
    bgColor: bgColor,
  );
}

class TagsSelectionWidget extends ToggleSelectionWidget {
  final User user;
  final bool canEdit;
  final List<Tag> tags;

  TagsSelectionWidget(this.user, this.canEdit, this.tags);

  @override
  createState() => new TagsSelectionWidgetState(user, canEdit, tags);
}

class TagsSelectionWidgetState extends ToggleSelectionWidgetState {
  final User user;
  final bool canEdit;
  final List<Tag> tags;

  TagsSelectionWidgetState(this.user,this.canEdit, this.tags);

  @override
  List<Widget> buildToggles() {

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
          }
      );
    }).toList();
  }
}

class SkillsSelectionPage {

  static void show(BuildContext context, User user, bool canEdit, List<Tag> tags) {
    ToggleSelectionPage.show(
        context,
        "Stylist Skills",
        canEdit ? "Select the skills you want to promote" : "Skills",
            (context) {
          return new TagsSelectionWidget(user, canEdit, tags);
        }
    );
  }
}


class InterestsSelectionPage {

  static void show(BuildContext context, User user, bool canEdit, List<Tag> tags) {
    ToggleSelectionPage.show(
      context,
      "Interests & Hobbies",
      canEdit ? "Select interests that you want to share" : "Interests",
      (context) {
        return new TagsSelectionWidget(user, canEdit, tags);
      }
    );
  }
}


