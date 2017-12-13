import 'package:flutter/material.dart';
import 'page.dart';
import 'package:hythr/content/user.dart';
import 'package:hythr/widgets/current_user_data.dart';

class SettingsPage extends StatelessWidget {

  show(BuildContext context) {
    new Page(title: "Settings", child: this).show(context);
  }

  toggle(bool value, User user) {
    user.firebaseRef().child("is_stylist").set(value);
  }

  @override
  Widget build(BuildContext context) {

    User user = CurrentUserData.of(context);

    return new ListView(
      children: [
        new SwitchListTile(
          secondary: const Icon(Icons.person_pin),
          title: const Text("I am a Stylist"),
          value: user.isStylist,
          onChanged: (value) {
            toggle(value, user);
          }
        )
      ]
    );
  }
}

