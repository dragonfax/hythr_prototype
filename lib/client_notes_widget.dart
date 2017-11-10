import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'content/client_note.dart';

class ClientNotesWidget extends StatelessWidget {
  final List<ClientNote> notes;
  final String client;

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

    return new Scaffold(
      appBar: new AppBar(title: new Text(client)),
      body: new CustomScrollView( slivers: [sliverList])
    );
  }

  static show(BuildContext context, List<ClientNote> notes, String client) {
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new ClientNotesWidget(notes, client);
        }
      )
    );
  }
}