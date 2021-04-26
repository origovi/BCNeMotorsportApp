import 'package:bcnemotorsportapp/models/ToDoData.dart';
import 'package:bcnemotorsportapp/widgets/ToDo.dart';
import 'package:flutter/material.dart';

class ToDoSectionData {
  List<ToDoData> _data;

  ToDoSectionData(this._data);

  get data => _data;
}