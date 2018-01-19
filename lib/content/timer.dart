
import 'client.dart';
import 'package:flutter/foundation.dart';

class Timer {
  final Client client;
  final int timer;
  final String title;

  Timer({ this.client, @required this.timer,  this.title });
}

List<Timer> timers = [];
