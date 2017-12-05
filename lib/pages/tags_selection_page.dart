import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hythr/content/content.dart';
import 'package:hythr/widgets/toggle_button.dart';

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

abstract class Tag {
  final String name;
  final ImageIcon icon;
  final List<Tag> children;
  final String type;

  Tag(this.name, this.icon, this.children, this.type);

  bool hasChildren() {
    return children != null && children.isNotEmpty;
  }

  List<String> getTagList(User user);

  bool getValue(User user) {
    return getTagList(user).contains(name);
  }

  toggleOn(User user) {
    var ref = FirebaseDatabase.instance.reference().child('/users/' + user.googleId + '/' + type + '/' + name);
    ref.set(true);
  }

  toggleOff(User user) {
    var ref = FirebaseDatabase.instance.reference().child('/users/' + user.googleId + '/' + type + '/' + name);
    ref.set(null);
  }
}

class TagSwitch extends ToggleButton {

  final User user;
  final Tag tag;
  final VoidCallback onChanged;
  final VoidCallback onLongPress;
  final Color bgColor;
  final bool value;

  TagSwitch({
    @required this.user,
    @required this.tag,
    @required this.onChanged,
    this.onLongPress,
    this.bgColor = Colors.black,
    this.value = false
  }) : super(
    name: tag.name,
    icon: tag.icon,
    value: value,
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
  final DatabaseReference document;

  const TagsSelectionWidget({
    @required this.hint,
    @required this.user,
    this.canEdit = true,
    @required this.tags,
    this.document
  });

  @override
  createState() => new TagsSelectionWidgetState();
}

class TagsSelectionWidgetState extends State<TagsSelectionWidget> {

  List<Widget> buildToggles(BuildContext context, List<String> selectedTags) {

    int index = 0;
    return widget.tags.map((tag){
      index++;
      return new TagSwitch(
          user: widget.user,
          tag: tag,
          bgColor: blacks[index % blacks.length],
          value: selectedTags.contains(tag.name),
          onChanged: ! widget.canEdit ? null : () {
            if ( selectedTags.contains(tag.name) ) {
              tag.toggleOff(widget.user);
            } else {
              tag.toggleOn(widget.user);
            }
          },
          /* onLongPress: ! tag.hasChildren() ? null : () {
            InterestsSelectionPage.show(context,user,tag.children);
          }, */
      );
    }).toList();
  }

  Widget buildPage(List<String> selectedTags){
     return new DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.black
      ),
      child: new Column(
        children: [
          new Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: new Text(widget.hint, style: const TextStyle(fontStyle: FontStyle.italic))
          ),
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              children: buildToggles(context, selectedTags)
            )
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<Event>(
      stream: widget.document.onValue,
      builder: (BuildContext context, AsyncSnapshot<Event> asyncEvent) {
        Map data = asyncEvent?.data?.snapshot?.value;
        List<String> selectedTags = data?.keys?.toList() ?? <String>[];
        return buildPage(selectedTags);
      }
    );
  }
}

