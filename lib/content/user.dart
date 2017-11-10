import 'package:flutter/material.dart';
import 'notification.dart' as notification;
import 'gallery.dart';
import 'stylist.dart';

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

  List<notification.Notification> notifications = [];
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

        final nt = notification.getNotificationTypeFromString(subJson['type']);
        switch (nt) {
          case notification.NotificationType.appointment_request:
            notifications.add(new notification.AppointmentRequest.fromJson(subJson));
            break;
          case notification.NotificationType.client_referral:
            notifications.add(new notification.ClientReferral.fromJson(subJson));
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