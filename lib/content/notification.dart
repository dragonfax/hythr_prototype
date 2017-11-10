import 'package:flutter/material.dart';

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
