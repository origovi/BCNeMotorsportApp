import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ToDoData {
  List<ToDo> _data;
  final String _dbId;

  // CONSTRUCTORS
  factory ToDoData.fromDatabase(QuerySnapshot snapshot, String dbId) {
    Map<String, Map<String, dynamic>> aux = {};
    snapshot.docs.forEach((element) => aux[element.id] = element.data());
    return new ToDoData.fromRaw(aux, dbId);
  }

  ToDoData.fromRaw(Map<String, Map<String, dynamic>> data, String dbId) : _dbId = dbId {
    _data = [];
    data.forEach((key, value) => _data.add(ToDo.fromRaw(value, id: key)));
  }

  // GETTERS
  List<ToDo> get allToDos => _data;
  List<ToDo> get myToDos => _data.where((element) => element.personIds.contains(_dbId)).toList();
  List<ToDo> get sectionToDosExcMine => _data.where((element) => element.personIds.any((element) => element != _dbId)).toList();

  // METHODS
  bool existsToDo(String id) {
    return _data.any((element) => element.id == id);
  }

  void addToDo(ToDo newToDo) {
    if (!existsToDo(newToDo.id)) _data.add(newToDo);
  }

  void completeToDo(String id) {
    for (ToDo toDo in _data) {
      if (toDo.id == id) {
        toDo.complete();
        return;
      }
    }
  }

  void incompleteToDo(String id) {
    for (ToDo toDo in _data) {
      if (toDo.id == id) {
        toDo.incomplete();
        return;
      }
    }
  }
}
