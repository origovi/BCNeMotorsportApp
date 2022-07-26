import 'package:flutter/material.dart';

class Person {
  String _dbId;
  List<String> _fcmTokens; // can be null
  String _name;
  String _surnames;
  bool _teamLeader;
  bool _hasAbout;
  String _about;
  String _email;
  int _toDosCompleted;
  // sectionId,   field,   value
  Map<String, Map<String, dynamic>> _sections;
  //la foto aniria aqui

  // CONSTRUCTORS
  Person(
      {String dbId,
      List<String> fcmTokens,
      @required String name,
      @required String surnames,
      Map<String, Map<String, dynamic>> sections = const {},
      bool hasAbout = false,
      String about,
      int toDosCompleted = 0,
      @required String email,
      @required bool teamLeader}) {
    _dbId = dbId;
    _fcmTokens = fcmTokens;
    _name = name;
    _surnames = surnames;
    _teamLeader = teamLeader;
    _hasAbout = hasAbout;
    _about = about;
    _email = email;
    _sections = sections;
    _toDosCompleted = toDosCompleted;
  }

  Person.fromRaw(Map<String, dynamic> data) {
    _dbId = data['dbId'];
    _fcmTokens = List<String>.from(data['fcmTokens'] ?? []);
    _name = data['name'];
    _surnames = data['surname'];
    _teamLeader = data['teamLeader'];
    _hasAbout = data['hasAbout'];
    _about = data['about'];
    _email = data['email'];
    _sections = new Map<String, Map<String, dynamic>>.from(data['sections']);
    _toDosCompleted = data['toDosCompleted'] ?? 0;
  }

  // GETTERS
  String get dbId => _dbId;
  /// Can be null
  List<String> get fcmTokens => _fcmTokens;
  String get profilePhotoName => _dbId + '.jpg';
  String get name => _name;
  String get surname => _surnames;
  bool get isTeamLeader => _teamLeader;
  String get completeName => _name + ' ' + _surnames;
  bool get hasAbout => _hasAbout;
  String get about => _about;
  String get email => _email;
  Map<String, Map<String, dynamic>> get sections => _sections;
  int get toDosCompleted => _toDosCompleted;

  List<String> get memberSectionIds {
    List<String> res = [];
    _sections.forEach((key, value) {
      res.add(key);
    });
    return res;
  }
  
  List<String> get chiefSectionIds {
    List<String> res = [];
    _sections.forEach((key, value) {
      if (value['chief']) res.add(key);
    });
    return res;
  }

  List<String> get onlyMemberSectionIds {
    List<String> res = [];
    _sections.forEach((key, value) {
      if (!value['chief']) res.add(key);
    });
    return res;
  }

  String role(String sectionId) => _sections[sectionId]['role'] ?? "Internal Error";

  // SETTERS
  set about(String newAbout) {
    _hasAbout = (newAbout != "");
    _about = newAbout;
  }

  void setDbId(String newDbId) => _dbId = newDbId;

  // METHODS
  void addFcmToken(String newFcmToken) => _fcmTokens.add(newFcmToken);
  
  void incrementToDosCompleted() => _toDosCompleted++;

  Map<String, dynamic> toRaw() {
    Map<String, dynamic> res = {};
    res['dbId'] = _dbId;
    res['fcmTokens'] = _fcmTokens;
    res['name'] = _name;
    res['surname'] = _surnames;
    res['teamLeader'] = _teamLeader;
    res['about'] = _about;
    res['hasAbout'] = _hasAbout;
    res['email'] = _email;
    res['sections'] = _sections;
    res['toDosCompleted'] = _toDosCompleted;
    return res;
  }
}
