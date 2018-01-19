import 'package:flutter/material.dart';
import 'package:hythr/content/timer.dart';
import 'page.dart';


class TimerListButton extends StatelessWidget {
  @override
  build(context) {
    return new IconButton(
      icon: const Icon(Icons.timer, color: Colors.white),
      tooltip: "Timers",
      onPressed: () {
        TimersListPage.show(context);
      }
    );
  }
}

class TimersListPage extends StatelessWidget {

   static show(BuildContext context) {
    new Page(
            title: "Active Timers",
            child: new TimersListPage()
    ).show(context);
  }

  @override
  build(content) {
     return new ListView(
       itemExtent: 40.0,
       children: timers.map((timer) {
         return new ListTile(
           leading: new Icon(Icons.timer),
           title: new Text(timer.client.name + ' ' + timer.title),
           subtitle: new Text(timer.timer.toString() + ' minutes'),
         );
       }).toList()
     );
  }

}