import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:flutter/material.dart';

class ToDoData {
  List<ToDo> _data;

  ToDoData(this._data);

  get data => _data;
}