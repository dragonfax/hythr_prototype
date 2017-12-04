import 'package:flutter/material.dart';
import 'notification.dart' as notification;
import 'gallery.dart';
import 'stylist.dart';
import 'client_note.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

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


  Map<String,String> toFirebaseUpdate() {
    return { "real_name": realName, "email": email, "photo_url": photoUrl };
  }

  User.fromFirebaseSnapshot(DataSnapshot snapshot) {
    realName = snapshot.value["real_name"];
    email = snapshot.value["email"];
    photoUrl = snapshot.value["photo_url"];
    googleId = snapshot.key;
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