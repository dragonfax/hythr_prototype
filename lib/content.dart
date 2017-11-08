import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:convert' show JSON;
import 'package:flutter/services.dart' show rootBundle;

Future<DataRoot> readContent({ String filename = 'assets/content.json' }) async {
  String contentJson = await rootBundle.loadString(filename);

  var json = JSON.decode(contentJson);

  return new DataRoot.fromJson(json);
}

class Skill {
  String name;
  ImageIcon icon;

  Skill(this.name, this.icon);

  bool getValue(User user) {
    return user.skills.contains(name);
  }

  toggle(User user) {
    if ( user.skills.contains(name) ) {
      user.skills.remove(name);
    } else {
      user.skills.add(name);
    }
  }

  Skill.fromJson(Map json) {
    name = json['name'];
    icon = new ImageIcon(new AssetImage(json['icon']));
  }
}

enum NotificationType { appointment_request, client_referral }

NotificationType getNotificationTypeFromString(String str) {
  final fqstr = 'NotificationType.$str';
  final t = NotificationType.values.firstWhere((e)=> e.toString() == fqstr, orElse: () => null);
  if ( t == null ) {
    throw new Exception("Bad state: no notification type '$str'");
  }
  return t;
}

abstract class Notification {

  ListTile buildListTile() {
    return new ListTile(
      leading: new Icon(getIcon()),
      title: new Text(toString())
    );
  }

  IconData getIcon();

  String toString() {
    return "";
  }
}

class AppointmentRequest extends Notification {
  String client;

  @override
  IconData getIcon() {
    return Icons.mail;
  }

  @override
  String toString() {
    return "Your client $client would like to schedule an appointment.";
  }

  AppointmentRequest.fromJson(Map json) {
    client = json['client'];
  }
}

class ClientReferral extends Notification {
  String client;
  String stylist;

  @override
  IconData getIcon() {
    return Icons.people;
  }

  @override
  String toString() {
    return "Your collegue $stylist has referred a client $client to you.";
  }

  ClientReferral.fromJson(Map json) {
    client = json['client'];
    stylist = json['stylist'];
  }
}

class Picture {
  String asset;
  bool isSelfie = false;
  bool wasProfile = false;
  bool isProfile = false;
  bool isClient = false;

  Picture.fromJson(Map json) {
    asset = json['asset'];

    if ( json.containsKey('is_selfie') ) {
      isSelfie = json['is_selfie'];
    }

    if ( json.containsKey('was_profile') ) {
      wasProfile = json['was_profile'];
    }

    if ( json.containsKey('is_profile') ) {
      isProfile = json['is_profile'];
    }

    if ( json.containsKey('is_client') ) {
      isClient = json['is_client'];
    }

  }
}

class Salon {
  String name;
  String address;
  String hours;
  String phone;

  Salon.fromJson(Map json) {
    if ( json != null ) {
      name = json['name'];
      address = json['address'];
      hours = json['hours'];
      phone = json['phone'];
    }
  }
}

class User {
  bool isStylist = false;
  String username;
  String realName;
  String phone;
  Salon salon;
  List<String> interests = [];
  List<String> skills = [];
  List<String> certifications = [];

  List<String> clients = [];
  List<String> followingStylists = [];

  List<Notification> notifications = [];
  List<Picture> gallery = [];


  User.fromJson(Map json) {
    username = json['username'];
    realName = json['real_name'];
    isStylist = json['is_stylist'] ?? false;

    if (json['salon'] != null ) {
      salon = new Salon.fromJson(json['salon']);
    }

    phone = json['phone'];

    interests = ( json['interests'] ?? <String>[] ).map((s) { return s; } ).toList();

    skills = ( json['skills'] ?? <String>[] ).map((s) { return s; } ).toList();

    certifications =  (json['certifications'] ?? <String>[] ).map((s) { return s; }).toList();

    clients = ( json['clients'] ?? <String>[]).map((clientName){ return clientName; }).toList();

    followingStylists = ( json['following_stylists'] ?? <String>[]).map((s) { return s; }).toList();

    notifications = [];
    if ( json.containsKey('notifications') ) {
      json['notifications'].forEach((Map subJson) {

        final nt = getNotificationTypeFromString(subJson['type']);
        switch (nt) {
          case NotificationType.appointment_request:
            notifications.add(new AppointmentRequest.fromJson(subJson));
            break;
          case NotificationType.client_referral:
            notifications.add(new ClientReferral.fromJson(subJson));
            break;
        }
      });
    }

    gallery = [];
    if ( json.containsKey('gallery') ) {
      gallery = json['gallery'].map((subJson) { return new Picture.fromJson(subJson); }).toList();
    }
  }

  getProfilePicture() {
    final profilePhoto = gallery.firstWhere((p) { return p.isProfile; }, orElse: () => null);
    if ( profilePhoto != null ) {
      return new Image.asset(profilePhoto.asset);
    }
    return new Icon(Icons.person);
  }
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

  List<Skill> skills;

  DataRoot() {
    users = new Map();
  }

  DataRoot.fromJson(Map json) {

    users = new Map();

    json['users'].forEach((userJson) {
      users[userJson['username']] = new User.fromJson(userJson);
    });

    currentUser = stylists()[0];

    skills = json['skills'].map((d) { return new Skill.fromJson(d); }).toList();
  }
}