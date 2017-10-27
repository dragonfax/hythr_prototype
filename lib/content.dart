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
  final t = NotificationType.values.firstWhere((e)=> e.toString() == fqstr);
  if ( t == null ) {
    throw "Bad state: no notification type '$str'";
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
  }
}

class Stylist {
  String username;
  String realName;
  String photo;
  List<String> clients;
  List<Notification> notifications;

  Stylist.fromJson(Map json) {
    username = json['username'];
    realName = json['real_name'];
    photo = json['photo'];

    clients = [];
    json['clients'].forEach((clientName){
      clients.add(clientName);
    });

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
  String currentUserName;
  Map<String,Stylist> stylists;
  Map<String,HairClient> clients;
  Stylist currentUser;

  DataRoot() {
    stylists = new Map();
    clients = new Map();
  }

  DataRoot.fromJson(Map json) {
    currentUserName = json['user'];

    stylists = new Map();
    json['stylists'].forEach((stylistData) {
      stylists[stylistData['username']] = new Stylist.fromJson(stylistData);
    });

    clients = new Map();
    json['clients'].forEach((clientData) {
      clients[clientData['username']] = new HairClient.fromJson(clientData);
    });

    currentUser = stylists[currentUserName];
  }
}