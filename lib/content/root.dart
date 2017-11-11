import 'dart:async' show Future;
import 'dart:convert' show JSON;
import 'package:flutter/services.dart' show rootBundle;

import 'user.dart';
import 'tag.dart';

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

  List<Tag> skills;
  List<Tag> interests;

  DataRoot() {
    users = new Map();
  }

  DataRoot.fromJson(Map json) {

    users = new Map();

    json['users'].forEach((userJson) {
      users[userJson['username']] = new User.fromJson(userJson);
    });

    currentUser = stylists()[0];

    skills = json['skills'].map((d) { return new Tag.fromJson(d, TagClass.SKILL); }).toList();

    interests = json['interests'].map((d) { return new Tag.fromJson(d, TagClass.INTEREST); }).toList();
  }
}