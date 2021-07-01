import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PersonsData {
  //   dbId,  Person
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

  Person personById(String dbId) => _data[dbId];
  Person personByIndex(int index) => _data.values.elementAt(index);

  Map<String, dynamic> personSections(String dbId) => _data[dbId].sections;

  // return maxLenghtRes Persons whose completename matches best with text
  List<Person> personsThatCoincideCompleteName(String text, {@required List<Person> exclude}) {
    const int maxLengthRes = 5;
    List<Person> res = [];
    List<Pair<int, Person>> coincidencia = [];
    dataList.forEach((element) {
      coincidencia.add(Pair(Functions.lcs(element.completeName.toLowerCase(), text.toLowerCase()), element));
    });
    coincidencia.sort((a, b) => b.first.compareTo(a.first));
    exclude.forEach((elementExc) =>
        coincidencia.removeWhere((elementCoin) => elementCoin.second.dbId == elementExc.dbId));
    for (int i = 0; i < Functions.min(coincidencia.length, maxLengthRes); i++) {
      res.add(coincidencia[i].second);
    }
    return res;
  }

  bool existsPersonWithEmail(String email) {
    for (Person person in _data.values) {
      if (person.email == email) return true;
    }
    return false;
  }
}
