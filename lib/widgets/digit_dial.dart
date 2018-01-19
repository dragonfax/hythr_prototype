import 'package:flutter/material.dart';

class Digit {
  /* just an indirect reference (pointer) to a number value */

  int value = 0;
}

class DigitDial extends StatefulWidget {
  final Digit digit;

  DigitDial(this.digit);

  @override
  createState() => new DigitalDialState(digit);
}

class DigitalDialState extends State {
  Digit digit;

  DigitalDialState(this.digit) {
    if ( digit == null ) {
      digit = new Digit();
    }
  }

  raise() {
    setState(() {
      digit.value++;
      if ( digit.value > 9 ) {
        digit.value = 9;
      }
    });
  }

  lower() {
    setState(() {
      digit.value--;
      if ( digit.value < 0 ) {
        digit.value = 0;
      }
    });
  }

  @override
  build(context) {

    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        new FlatButton(
          child: const Icon(Icons.arrow_drop_up),
          onPressed: raise,
        ),
        new Text(digit.value.toString(), style: new TextStyle( fontSize: 40.0)),
        new FlatButton(
          child: const Icon(Icons.arrow_drop_down),
          onPressed: lower,
        ),
      ]
    );
  }
}