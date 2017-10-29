import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:convert' show JSON;
import 'package:flutter/services.dart' show rootBundle;

Future<DataRoot> readContent() async {
  String contentJson = await rootBundle.loadString('assets/content.json');

  var json = JSON.decode(contentJson);

  return new DataRoot.fromJson(json);
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

class Stylist {
  String username;
  String realName;
  String phone;
  Salon salon;
  List<String> interests;
  List<String> certifications;

  List<String> clients;
  List<String> followingStylists;

  List<Notification> notifications;
  List<Picture> gallery;


  Stylist.fromJson(Map json) {
    username = json['username'];
    realName = json['real_name'];

    salon = new Salon.fromJson(json['salon']);
    phone = json['phone'];

    interests = ( json['interests'] ?? <String>[] ).map((s) { return s; } ).toList();

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

class HairClient {
  String username;
  String realName;
  String photo;

  HairClient.fromJson(Map json) {
    username = json['username'];
    realName = json['real_name'];
    photo = json['photo'];
  }
}

class DataRoot {
  Map<String,Stylist> stylists;
  Map<String,HairClient> clients;
  Stylist currentUser;

  DataRoot() {
    stylists = new Map();
    clients = new Map();
  }

  DataRoot.fromJson(Map json) {

    stylists = new Map();
    json['stylists'].forEach((stylistData) {
      stylists[stylistData['username']] = new Stylist.fromJson(stylistData);
    });

    clients = new Map();
    json['clients'].forEach((clientData) {
      clients[clientData['username']] = new HairClient.fromJson(clientData);
    });

    currentUser = stylists.values.toList()[0];
  }
}