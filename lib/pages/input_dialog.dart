import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class InputDialog extends StatelessWidget {
  final String title;
  final String labelText;
  final String actionLabel;
  final String initial;

  InputDialog({ @required this.title, this.labelText, this.actionLabel, this.initial });

  show(BuildContext context) async {
    return await showDialog<String>(
        context: context,
        child: this
    );
  }

  @override
  Widget build(BuildContext context) {
    String value;
    return new AlertDialog(
        title: new Text(title),
        content: new TextField(
          controller: new TextEditingController(text: initial == null ? "" : initial),
            decoration: new InputDecoration(
                labelText: labelText == null ? "Enter" : labelText
            ),
            onChanged: (t) {
              value = t;
            },
            onSubmitted: (t) async {
              value = t;
              Navigator.of(context).pop(value);
            }
        ),
        actions: [
          new FlatButton(
              child: new Text(actionLabel == null ? "Okay" : actionLabel),
              onPressed: () async {
                Navigator.of(context).pop(value);
              }
          )
        ]
    );
  }
}