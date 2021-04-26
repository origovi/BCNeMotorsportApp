import 'package:bcnemotorsportapp/models/CalendarData.dart';
import 'package:bcnemotorsportapp/models/TeamData.dart';
import 'package:bcnemotorsportapp/models/ToDoAllData.dart';
import 'package:flutter/material.dart';

class AllData {
  CalendarData _calendarData;
  ToDoAllData _toDoAllData;
  TeamData _teamData;

  AllData();
  AllData.fromCloud();

  get calendarData => _calendarData;
  get toDoAllData => _toDoAllData;
  get teamData => _teamData;
}