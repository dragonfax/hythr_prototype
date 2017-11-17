import 'dart:async' show Future;
import 'dart:convert' show JSON;
import 'package:flutter/services.dart' show rootBundle;

import 'user.dart';
import 'timeline.dart';

DataRoot root = new DataRoot();

Future<DataRoot> readContent({ String filename = 'assets/content.json' }) async {
  String contentJson = await rootBundle.loadString(filename);

  var json = JSON.decode(contentJson);

  return new DataRoot.fromJson(json);
}

class DataRoot {
  Map<String,User> users;

  List<User> stylists() {
    return users.values.where((u) { return u.isStylist; }).toList();
  }

  List<User> clients() {
    return users.values.where((u) { return ! u.isStylist; }).toList();
  }

  User currentUser;

  List<TimeLine> timeline;

  DataRoot() {
    users = new Map();
  }

  DataRoot.fromJson(Map json) {

    users = new Map();

    json['users'].forEach((userJson) {
      users[userJson['username']] = new User.fromJson(userJson);
    });

    currentUser = stylists()[0];

    timeline = json['timeline'].map((d) { return TimeLine.subclassFromJson(d); }).toList();
  }
}