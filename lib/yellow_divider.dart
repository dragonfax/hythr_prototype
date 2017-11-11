import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class YellowDivider extends StatelessWidget {

  Widget build(BuildContext context) {
    return new ConstrainedBox(
        constraints: new BoxConstraints(minHeight: 4.0, minWidth: 10.0),
        child: new DecoratedBox(
            decoration: new BoxDecoration(color: Colors.yellow)
        )
    );
  }
}
