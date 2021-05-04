import 'package:flutter/material.dart';

class Person {
  String _dbId;
  String _name;
  String _surname;
  bool _teamLeader;
  bool _hasAbout;
  String _about;
  String _email;
  // sectionId,   field,   value
  Map<String, Map<String, dynamic>> _sections;
  //la foto aniria aqui

  // CONSTRUCTORS
  Person({dbId, name, surname, sections, hasAbout, about, email, teamLeader}) {
    _dbId = dbId;
    _name = name;
    _surname = surname;
    _teamLeader = teamLeader;
    _hasAbout = hasAbout;
    _about = about;
    _email = email;
    _sections = sections;
  }

  Person.fromRaw(Map<String, dynamic> data) {
    _dbId = data['dbId'];
    _name = data['name'];
    _surname = data['surname'];
    _teamLeader = data['teamLeader'];
    _hasAbout = data['hasAbout'];
    _about = data['about'];
    _email = data['email'];
    _sections = new Map<String, Map<String, dynamic>>.from(data['sections']);
  }

  // GETTERS
  String get dbId => _dbId;
  String get name => _name;
  String get surname => _surname;
  bool get isTeamLeader => _teamLeader;
  String get completeName => _name + ' ' + _surname;
  bool get hasAbout => _hasAbout;
  String get about => _about;
  String get email => _email;

  String role(String sectionId) => _sections[sectionId]['role'];

  // METHODS
  Map<String, dynamic> toRaw() {
    Map<String, dynamic> res = {};
    res['dbId'] = _dbId;
    res['name'] = _name;
    res['surname'] = _surname;
    res['teamLeader'] = _teamLeader;
    res['about'] = _about;
    res['hasAbout'] = _hasAbout;
    res['email'] = _email;
    res['sections'] = _sections;
    return res;
  }
}
