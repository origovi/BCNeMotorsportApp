import 'package:flutter/material.dart';

class Person {
  String _dbId;
  String _name;
  String _surname;
  String _about;
  String _email;
  // sectionId,   field,   value
  Map<String, Map<String, dynamic>> _sections;
  //la foto aniria aqui

  // CONSTRUCTORS
  Person({dbId, name, surname, sections, about, email}) {
    _dbId = dbId;
    _name = name;
    _surname = surname;
    _about = about;
    _email = email;
    _sections = sections;
  }

  Person.fromRaw(Map<String, dynamic> data) {
    _dbId = data['dbId'];
    _name = data['name'];
    _surname = data['surname'];
    _about = data['about'];
    _email = data['email'];
    _sections = new Map<String, Map<String, dynamic>>.from(data['sections']);
  }

  // GETTERS
  String get dbId => _dbId;
  String get name => _name;
  String get surname => _surname;
  String get completeName => _name + ' ' + _surname;
  String get about => _about;
  String get email => _email;

  String role(String sectionId) => _sections[sectionId]['role'];
}
