import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Announcement {
  String _id;
  String _title;
  String _body;
  DateTime _whenAdded;
  bool _global;
  String _sectionId;

  Announcement({
    String id = "",
    @required String title,
    @required String body,
    @required bool global,
    String sectionId,
    DateTime whenAdded,
  })  :
        _id = id,
        _title = title,
        _body = body,
        _global = global,
        _sectionId = sectionId,
        _whenAdded = whenAdded ?? DateTime.now();

  Announcement.fromRaw(Map<String, dynamic> data, {String announcementId = ""})
      : _title = data['title'],
        _id = announcementId,
        _body = data['body'],
        _global = data['global'],
        _sectionId = data['sectionId'],
        _whenAdded = DateTime.tryParse(data['whenAdded'].toDate().toString());

  String get id => _id;
  String get title => _title;
  String get body => _body;
  DateTime get whenAdded => _whenAdded;
  bool get global => _global;
  String get sectionId => _sectionId;

    void addId(String id) {
    assert(_id == "", "Cannot add an id to an announcement that already has one");
    _id = id;
  }

  Map<String, dynamic> toRaw() {
    Map<String, dynamic> res = {};
    res['title'] = _title;
    res['body'] = _body;
    res['global'] = _global;
    res['whenAdded'] = Timestamp.fromDate(_whenAdded);
    if (!global) res['sectionId'] = _sectionId;
    return res;
  }
}
