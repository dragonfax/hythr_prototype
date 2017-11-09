import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


/* toggle doesn't track its own state, or change any state when clicked.
   it relies ont he parent to do that and give it its new state (value)

   Its only useful for alternating between on/off colors. on behalf o the parent.
 */
class ToggleButton extends StatelessWidget {

  final String name;
  final ImageIcon icon;
  final bool value;
  final VoidCallback onChanged;
  final VoidCallback onLongPress;
  final Color onColor;
  final Color offColor;
  final Color bgColor;

  ToggleButton({
    @required this.name,
    @required this.icon,
    @required this.value,
    @required this.onChanged,
    this.onLongPress,
    this.onColor = Colors.yellow,
    this.offColor = Colors.white,
    this.bgColor = Colors.black,
  });

  Widget build(BuildContext context) {
    List<Widget> deco = [
      icon,
      new Text(name)
    ];

    if ( onLongPress != null ) {
      deco.add(new Text("...", style: new TextStyle(fontSize: 24.0)));
    } else {
      deco.add(new Text("   ", style: new TextStyle(fontSize: 24.0)));
    }

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
                  child: new Center(
                    child:
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: deco
                      )
                  ),
                  onTap: onChanged,
                  onLongPress: onLongPress
                )
            )
        ));
  }
}
