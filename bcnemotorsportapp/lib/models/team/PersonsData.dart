import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PersonsData {
  // sectionId, SectionData
  Map<String, Person> _data;

  // CONSTRUCTORS
  PersonsData(this._data);

  factory PersonsData.fromDatabase(QuerySnapshot snapshot) {
    Map<String, Map<String, dynamic>> aux = {};
    snapshot.docs.forEach((element) => aux[element.id] = element.data());
    return new PersonsData.fromRaw(aux);
  }

  PersonsData.fromRaw(Map<String, Map<String, dynamic>> data) {
    _data = {};
    data.forEach((key, value) => _data[key] = Person.fromRaw(value));
  }

  // GETTERS
  List<Person> get dataList => _data.values.toList();
  Map<String, Person> get data => _data;
  int get size => _data.length;

  Person personById(String id) => _data[id];

  Person personByIndex(int index) => _data.values.elementAt(index);
}
