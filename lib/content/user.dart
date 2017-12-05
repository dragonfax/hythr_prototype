import 'package:flutter/material.dart';
import 'notification.dart' as notification;
import 'gallery.dart';
import 'stylist.dart';
import 'client_note.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

listToMap(List<String> list) {
  if ( list == null ) {
    return null;
  }
  Map<String,bool> m = {};
  list.forEach((i) {
    m[i] = true;
  });
  return m;
}

class User {
  bool isStylist = false;

  // TODO
  String photoUrl;
  String email;
  String googleId;

  String username;
  String realName;
  String phone;
  Salon salon;
  List<String> interests = [];
  List<String> skills = [];
  List<String> certifications = [];

  List<String> clients = [];
  Map<String,List<ClientNote>> clientNotes = {};
  List<String> followingStylists = [];

  List<notification.Notification> notifications = [];
  List<Picture> gallery = [];


  toFirebaseUpdate() {
    return {
      "real_name": realName,
      "email": email,
      "photo_url": photoUrl,

      "is_stylist": isStylist,
      "phone": phone,

      "salon": salon?.toFirebaseUpdate(),

      "interests": listToMap(interests),
      "skills": listToMap(skills),
      "certifications": listToMap(certifications),
    };
  }

  User(this.email);

  User.fromFirebaseSnapshot(DataSnapshot snapshot) {
    googleId = snapshot.key;

    realName = snapshot.value["real_name"];
    email = snapshot.value["email"];

    var json = snapshot.value;

    isStylist = json['is_stylist'] ?? false;
    photoUrl = snapshot.value["photo_url"];
    phone = json['phone'];

    if (json['salon'] != null ) {
      salon = new Salon.fromJson(json['salon']);
    }

    interests = json['interests'] == null ? <String>[] : json['interests'].keys.toList();

    skills = json['skills'] == null ? <String>[] : json['skills'].keys.toList();

    certifications = json['certifications'] == null ? <String>[] : json['certifications'].keys.toList();
  }

  User.fromGoogleUser(GoogleSignInAccount googleUser) {
    realName = googleUser.displayName;
    email = googleUser.email;
    photoUrl = googleUser.photoUrl;
    googleId = googleUser.id;
    // no username as they use email instead
  }

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

    clientNotes = ClientNote.fromJsonMap(json['client_notes']);

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

  String getInitials() {
    return realName.split(" ").map((String s){ return s[0];}).join("");
  }

  Widget getChip() {
    final profilePhoto = gallery.firstWhere((p) { return p.isProfile; }, orElse: () => null);
    if ( profilePhoto != null ) {
      return new CircleAvatar(
        backgroundImage: new AssetImage(profilePhoto.asset),
      );
    } else {
      return new CircleAvatar(
        backgroundColor: Colors.grey.shade800,
        child: new Text(getInitials())
      );
    }
  }
}