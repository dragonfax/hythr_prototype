import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'page.dart';
import 'content/root.dart';
import 'content/user.dart';

import 'content/client_note.dart';

class ClientNotesWidget extends StatelessWidget {
  final List<ClientNote> notes;
  final User client;

  ClientNotesWidget(this.notes, this.client);

  Widget build(BuildContext context) {

    SliverList sliverList = new SliverList(
        delegate: new SliverChildListDelegate(
          notes == null || notes.isEmpty ?  [ new Center(child:new Text("no notes")) ] :
          notes.map((note){
            return note.getWidget();
          }
        ).toList())
    );

    return new CustomScrollView( slivers: [sliverList]);
  }

  static show(BuildContext context, List<ClientNote> notes, User client) {
    new Page(title: client.realName, child: new ClientNotesWidget(notes, client)).show(context);
  }
}