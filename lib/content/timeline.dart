import 'package:flutter/material.dart';

TextSpan normalSpan(String text) {
  return new TextSpan(
    text: text,
    style: new TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),
  );
}

TextSpan boldSpan(String text) {
  return new TextSpan(
      text: text,
      style: new TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
  );
}

TextSpan italicSpan(String text) {
  return new TextSpan(
      text: text,
      style: new TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)
  );
}

TextSpan combineSpan(TextSpan span1, TextSpan span2) {
  return new TextSpan(
    children: [
      span1,
      span2,
    ]
  );
}

TextSpan combineSpans(List<TextSpan> spans) {
  return new TextSpan(children: spans);
}

abstract class TimeLine {

  final String username;

  TimeLine(this.username);

  TimeLine.fromJson(Map json): username = json['username'];

  Widget getWidget();

  static TimeLine subclassFromJson(Map json) {

    String type = json['type'];

    switch(type) {
      case 'profile_photo':
        return new ProfilePhoto.fromJson(json);
      case 'announcement':
        return new Announcement.fromJson(json);
      case 'client_photo':
        return new ClientPhoto.fromJson(json);
      case 'interest':
        return new Interest.fromJson(json);
      case 'inspiration':
        return new Inspiration.fromJson(json);
      case 'certification':
        return new Certification.fromJson(json);
      default:
        throw "unknown timeline type $type";
    }
  }
}

abstract class ImageTimeLine extends TimeLine {
  final String asset;

  ImageTimeLine.fromJson(Map json) : asset = json['asset'], super.fromJson(json);

  TextSpan getMessage();
  IconData getIcon();

  @override
  Widget getWidget() {
    return new Padding(
      padding: new EdgeInsets.symmetric(vertical: 10.0),
      child: new Column(
        children: [
          new ListTile(
            leading: new Icon(getIcon()),
            title: new RichText(text: getMessage())
          ),
          new Image.asset(asset)
        ]
      )
    );
  }
}

abstract class MessageTimeLine extends TimeLine {

  MessageTimeLine.fromJson(Map json): super.fromJson(json);

  TextSpan getMessage();
  IconData getIcon();

  @override
  Widget getWidget() {
    return new ListTile(
      leading: new Icon(getIcon()),
      title: new RichText(text: getMessage())
    );
  }
}

class ProfilePhoto extends ImageTimeLine {

  ProfilePhoto.fromJson(Map json) : super.fromJson(json);

  @override
  TextSpan getMessage() {
    return combineSpan(boldSpan(username),italicSpan(" added a new Profile Photo"));
  }

  @override
  IconData getIcon() {
    return Icons.person_outline;
  }
}

class Announcement extends MessageTimeLine {
  final String message;

  @override
  IconData getIcon() { return Icons.announcement; }

  @override
  TextSpan getMessage() { return combineSpans([normalSpan("from "),boldSpan("$username"),normalSpan(": "),italicSpan("$message")]); }

  Announcement.fromJson(Map json) : message = json['message'], super.fromJson(json);
}

class ClientPhoto extends ImageTimeLine {

  ClientPhoto.fromJson(Map json) : super.fromJson(json);

  @override
  TextSpan getMessage() { return combineSpan(boldSpan(username),italicSpan(" added a new Client Photo.")); }

  @override
  IconData getIcon() { return Icons.photo; }
}

class Interest extends MessageTimeLine {
  final String interest;

  @override
  IconData getIcon() { return Icons.shopping_basket; }

  @override
  TextSpan getMessage() { return combineSpan(boldSpan(username),italicSpan(" has added a new interest topic to their profile, $interest!")); }

  Interest.fromJson(Map json) : interest = json['interest'], super.fromJson(json);
}

class Inspiration extends ImageTimeLine {

  Inspiration.fromJson(Map json) : super.fromJson(json);

  @override
  TextSpan getMessage() { return combineSpan(boldSpan(username),italicSpan(" added a new Inspiration"));}

  @override
  IconData getIcon() { return Icons.photo_album; }
}

class Certification extends MessageTimeLine {
  final String certification;

  @override
  IconData getIcon() { return Icons.pan_tool; }

  @override
  TextSpan getMessage() { return combineSpans([boldSpan(username),italicSpan(" has added a new Certifications, "),boldSpan(certification)]); }

  Certification.fromJson(Map json) : certification = json['certification'], super.fromJson(json);
}
