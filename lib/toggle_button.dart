import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'set_state_callback.dart';

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

/* toggle doesn't track its own state, or change any state when clicked.
   it relies ont he parent to do that and give it its new state (value)

   Its only useful for alternating between on/off colors. on behalf o the parent.
 */
class ToggleButton extends StatelessWidget {

  final String name;
  final IconData icon;
  final bool value;
  final VoidCallback onChanged;
  final Color onColor;
  final Color offColor;
  final Color bgColor;

  ToggleButton({
    @required this.name,
    @required this.icon,
    @required this.value,
    @required this.onChanged,
    this.onColor = Colors.yellow,
    this.offColor = Colors.white,
    this.bgColor = Colors.black,
  });

  Widget build(BuildContext context) {
    return new DecoratedBox(
        decoration: new BoxDecoration(
            color: bgColor,
            gradient: new LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ new Color(bgColor.value + 0x101010), bgColor],
              tileMode: TileMode.repeated,
            )
        ),
        child: new DefaultTextStyle(
            style: new TextStyle(color: value ? onColor : offColor),
            child: new IconTheme(
                data: new IconThemeData(
                    color: value ? onColor : offColor
                ),
                child: new InkWell(
                    child: new Center(child:
                    new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          new Icon(icon),
                          new Text(name)
                        ]
                    )),
                    onTap: onChanged == null ? null : onChanged
                )
            )
        ));
  }
}

typedef List<Widget> ToggleBuilder(SetStateCallback callback);

abstract class ToggleSelectionPage  {
  final String title;
  final String hint;

  ToggleSelectionPage(this.title, this.hint);

  List<Widget> buildToggles(SetStateCallback callback);

  void show(BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(title: new Text(title)),
            body: new ToggleSelectionWidget( hint: hint, buildToggles: buildToggles )
          );
        }
      )
    );
  }
}

class ToggleSelectionWidget extends StatefulWidget {

  final String hint;
  final ToggleBuilder buildToggles;

  ToggleSelectionWidget({ this.hint, this.buildToggles });

  @override
  createState() => new ToggleSelectionWidgetState(this.hint, this.buildToggles);

}

class ToggleSelectionWidgetState extends State<ToggleSelectionWidget> {

  final String hint;
  final ToggleBuilder buildToggles;

  ToggleSelectionWidgetState(this.hint, this.buildToggles);

  Widget build(BuildContext context) {

    return new DecoratedBox(
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
            child: new GridView.count(
              crossAxisCount: 2,
              // shrinkWrap: true,
              childAspectRatio: 2.0,
              children: buildToggles(setState)
            )
          )
        ]
      )
    );
  }
}

typedef void OnChangeCallback(SetStateCallback f);
