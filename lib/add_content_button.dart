import 'package:flutter/material.dart';

enum AddButtons { post, video, selfie, clientNote }

class FloatingAddButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Add Content',
        child: new PopupMenuButton<AddButtons>(
          itemBuilder: (BuildContext context) => <PopupMenuEntry<AddButtons>>[
            new PopupMenuItem<AddButtons>(
                value: AddButtons.post,
                child: new Text('Add Image to Work Gallery')
            ),
            new PopupMenuItem<AddButtons>(
                value: AddButtons.selfie,
                child: new Text('Take a new Profile Pic')
            ),
            new PopupMenuItem<AddButtons>(
              value: AddButtons.clientNote,
              child: new Text('Add to Client Log')
            ),
            new PopupMenuItem<AddButtons>(
              value: AddButtons.video,
              child: new Text('Add a new Story/Video')
            )
          ]
        )
      );
  }
}
