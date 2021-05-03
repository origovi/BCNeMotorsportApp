import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SectionsData {
  // sectionId, SectionData
  Map<String, Section> _data;

  // CONSTRUCTORS
  SectionsData(this._data);

  factory SectionsData.fromDatabase(QuerySnapshot snapshot) {
    Map<String, Map<String, dynamic>> aux = {};
    snapshot.docs.forEach((element) => aux[element.id] = element.data());
    print(aux);
    return new SectionsData.fromRaw(aux);
  }

  SectionsData.fromRaw(Map<String, Map<String, dynamic>> data) {
    _data = {};
    data.forEach((key, value) => _data[key] = Section.fromRaw(value));
  }

  // GETTERS
  List<Section> get dataList => _data.values.toList();
  Map<String, Section> get data => _data;
  int get size => _data.length;

  Section sectionById(String id) => _data[id];

  Section sectionByIndex(int index) => _data.values.elementAt(index);
}
