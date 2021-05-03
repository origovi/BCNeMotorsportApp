import 'package:flutter/material.dart';

class Section {
  String _name;
  String _sectionId;
  List<String> _memberIds;
  List<String> _chiefIds;
  String _about;

  // CONSTRUCTORS
  Section({name, sectionId, memberIds, chiefIds, about}) {
    _name = name;
    _sectionId = sectionId;
    _memberIds = memberIds;
    _chiefIds = chiefIds;
    _about = about;
  }

  Section.fromRaw(Map<String, dynamic> data) {
    _name = data['name'];
    _sectionId = data['sectionId'];
    _memberIds = new List<String>.from(data['members']);
    _chiefIds = new List<String>.from(data['chiefs']);
    _about = data['about'];
  }

  // GETTERS
  int get size => _memberIds.length;
  String get name => _name;
  String get sectionId => _sectionId;
  List<String> get memberIds => _memberIds;
  int get numChiefs => _chiefIds.length;
  List<String> get chiefIds => _chiefIds;
  String get about => _about;

  // METHODS
  bool isChief(String dbId) {
    for (String chiefId in _chiefIds) {
      if (chiefId == dbId) return true;
    }
    return false;
  }

}