import 'package:flutter/material.dart';
import 'user.dart';

enum TagClass { SKILL, INTEREST }

class Tag {
  String name;
  ImageIcon icon;
  List<Tag> children;
  TagClass tagClass;

  bool hasChildren() {
    return children != null && children.isNotEmpty;
  }

  List<String> _getTagList(User user) {
    if ( tagClass == TagClass.SKILL ) {
      return user.skills;
    } else if ( tagClass == TagClass.INTEREST ) {
      return user.interests;
    }
    throw "tag had no tag class";
  }

  bool getValue(User user) {
    return _getTagList(user).contains(name);
  }

  toggle(User user) {
    List<String> l = _getTagList(user);
    if ( l.contains(name) ) {
      l.remove(name);
    } else {
      l.add(name);
    }
  }

  Tag.fromJson(Map json, TagClass tagClass) {
    name = json['name'];
    icon = new ImageIcon(new AssetImage(json['icon']));
    this.tagClass = tagClass;
    if ( json['children'] != null ) {
      children = json['children'].map((child){ return new Tag.fromJson(child, tagClass); }).toList();
    }
  }
}