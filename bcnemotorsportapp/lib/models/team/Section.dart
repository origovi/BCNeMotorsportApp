import 'package:flutter/material.dart';

class Section {
  String _name;
  String _id;
  List<String> _memberIds;
  List<String> _chiefIds;
  bool _hasAbout;
  String _about;

  // CONSTRUCTORS
  Section({@required String name, String id = "", List<String> memberIds, List<String> chiefIds, bool hasAbout, String about}) {
    _name = name;
    _id = id;
    _memberIds = memberIds ?? [];
    _chiefIds = chiefIds ?? [];
    _hasAbout = hasAbout ?? about.isNotEmpty;
    _about = about;
  }

  Section.fromRaw(Map<String, dynamic> data, {String id = ""}) {
    _name = data['name'];
    _id = id;
    _memberIds = new List<String>.from(data['members']);
    _chiefIds = new List<String>.from(data['chiefs']);
    _hasAbout = data['hasAbout'];
    _about = data['about'];
  }

  // GETTERS
  int get size => _memberIds.length;
  String get name => _name;
  String get sectionId => _id;
  int get numMembers => _memberIds.length;
  List<String> get memberIds => _memberIds;
  int get numChiefs => _chiefIds.length;
  List<String> get chiefIds => _chiefIds;
  List<String> get onlyMemberIds {
    List<String> res = [];
    _memberIds.forEach((element) {
      if (!chiefIds.contains(element)) res.add(element);
    });
    return res;
  }

  bool get hasAbout => _hasAbout;
  String get about => _about;

  // METHODS
  bool isChief(String dbId) {
    for (String chiefId in _chiefIds) {
      if (chiefId == dbId) return true;
    }
    return false;
  }

  void addId(String id) {
    _id = id;
  }

  Map<String, dynamic> toRaw() {
    Map<String, dynamic> res = {};
    res['name'] = _name;
    res['members'] = _memberIds;
    res['chiefs'] = _chiefIds;
    res['hasAbout'] = _hasAbout;
    if (_hasAbout) res['about'] = _about;
    return res;
  }
}
