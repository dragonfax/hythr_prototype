import 'package:flutter/material.dart';
import 'page.dart';
import 'package:hythr/content/user.dart';
import 'package:hythr/content/stylist.dart';

class ThickListTile extends StatelessWidget {
  /* keeps same horizontal spacing as a ListTile
    But includes room for a 3-line title, such as a multi-line text field.
   */

  final Widget leading;
  final Widget title;
  ThickListTile({this.leading, this.title});

  @override
  build(context) {
    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 100.0,
      child: new Row(
        children: [
          new Container(
            child: leading,
            width: 40.0,
            alignment: AlignmentDirectional.centerStart,
            margin: const EdgeInsetsDirectional.only(end: 16.0),
          ),
          new Expanded(child:title)
        ]
      ));
  }
}

class SalonInput extends StatelessWidget {
  final User user;

  SalonInput(this.user);

  show(context) {
    new Page(title: "Edit Salon", child: this).show(context);
  }

  deleteSalon(context) {

    user.firebaseRef().child("salon").remove();

    Navigator.of(context).pop();
  }

  saveSalon(context, name, address, hours, phone) {
    var salon = new Salon(
      name: name,
      address: address,
      hours: hours,
      phone: phone,
    );

    user.firebaseRef().child("salon").set(salon.toFirebaseUpdate());

    Navigator.of(context).pop();
  }

  @override
  Widget build(context) {
    var nameField = new TextField(
        decoration: const InputDecoration(hintText: "Salon Name"),
      controller: new TextEditingController(text: user.salon?.name)
    );

    var addressField = new TextField(
        maxLines: 3,
        decoration: const InputDecoration(hintText: "Address"),
        controller: new TextEditingController(text: user.salon?.address)
    );

    var hoursField = new TextField(
        decoration: const InputDecoration(hintText: "Hours"),
        controller: new TextEditingController(text: user.salon?.hours)
    );

    var phoneField = new TextField(
        decoration: const InputDecoration(hintText: "Phone"),
        controller: new TextEditingController(text: user.salon?.phone)
    );

    return new Column(children: [
      new ListTile(
          leading: const Icon(Icons.title),
          title: nameField
      ),
      new ThickListTile(
          leading: const Icon(Icons.map),
          title: addressField
      ),
      new ListTile(
          leading: const Icon(Icons.hourglass_full),
          title: hoursField,
      ),
      new ListTile(
          leading: const Icon(Icons.phone),
          title: phoneField
      ),
      new Align(
          alignment: Alignment.bottomRight,
          child: new Row(mainAxisSize: MainAxisSize.min, children: [
            new FlatButton(
                child: new Text("Delete Salon", style: new TextStyle( color: Colors.red)),
                onPressed: user.salon == null ? null : () { deleteSalon(context); } ),
            new FlatButton(
                child: new Text("Cancel"),
                onPressed: () { Navigator.of(context).pop(); } ),
            new FlatButton(
                child: new Text("Ok"),
                onPressed: () { saveSalon(context, nameField.controller.text, addressField.controller.text, hoursField.controller.text, phoneField.controller.text); })
          ])),
    ]);
  }
}
