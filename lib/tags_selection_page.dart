import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'content/user.dart';
import 'content/tag.dart';
import 'toggle_button.dart';

List<Color> blacks = [
  new Color(0xFF202020),
  new Color(0xFF161616),
  new Color(0xFF121212),
  new Color(0xFF101010),
  new Color(0xFF080808),
  new Color(0xFF060606),
  new Color(0xFF080808),
  new Color(0xFF101010),
  new Color(0xFF121212),
  new Color(0xFF161616),
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
  final User user;
  final bool canEdit;
  final List<Tag> tags;

  TagsSelectionWidget(this.user, this.canEdit, this.tags);

  @override
  createState() => new TagsSelectionWidgetState(user, canEdit, tags);
}

class TagsSelectionWidgetState extends State<TagsSelectionWidget> {
  final User user;
  final bool canEdit;
  final List<Tag> tags;

  TagsSelectionWidgetState(this.user,this.canEdit, this.tags);

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
            InterestsSelectionPage.show(context,user,canEdit,tag.children);
          },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.0,
        children: buildToggles(context)
    );
  }
}

class TagSelectionPage extends StatelessWidget {

  final String title;
  final String hint;
  final WidgetBuilder builder;

  TagSelectionPage(this.title, this.hint, this.builder);

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(title)),
        body: new DecoratedBox(
          decoration: new BoxDecoration(
            color: Colors.black
          ),
          child: new Column(
            children: [
              new Padding(
                  padding: new EdgeInsets.symmetric(vertical: 8.0),
                  child: new Text(hint, style: new TextStyle(fontStyle: FontStyle.italic))
              ),
              new Expanded(
                child: builder(context)
              )
            ]
          )
        )
    );
  }

  static void show(BuildContext context, String title, String hint, WidgetBuilder builder) {
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new TagSelectionPage(title, hint, builder);
        }
      )
    );
  }
}


class SkillsSelectionPage {

  static void show(BuildContext context, User user, bool canEdit, List<Tag> tags) {
    TagSelectionPage.show(
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
    TagSelectionPage.show(
      context,
      "Interests & Hobbies",
      canEdit ? "Select interests that you want to share" : "Interests",
      (context) {
        return new TagsSelectionWidget(user, canEdit, tags);
      }
    );
  }
}


