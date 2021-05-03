import 'package:bcnemotorsportapp/models/toDo/ToDoData.dart';
import 'package:bcnemotorsportapp/widgets/toDo/ToDo.dart';
import 'package:flutter/material.dart';

class ToDoSectionData {
  List<ToDoData> _data;

  ToDoSectionData(this._data);

  get data => _data;
}