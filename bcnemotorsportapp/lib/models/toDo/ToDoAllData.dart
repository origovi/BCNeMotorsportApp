import 'package:bcnemotorsportapp/models/toDo/ToDoSectionData.dart';
import 'package:flutter/material.dart';

class ToDoAllData {
  List<ToDoSectionData> _data;

  ToDoAllData(this._data);

  get data => _data;
}