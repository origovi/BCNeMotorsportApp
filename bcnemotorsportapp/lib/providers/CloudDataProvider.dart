import 'package:bcnemotorsportapp/models/AllData.dart';
import 'package:bcnemotorsportapp/models/CalendarData.dart';
import 'package:bcnemotorsportapp/models/TeamData.dart';
import 'package:bcnemotorsportapp/models/ToDoData.dart';
import 'package:bcnemotorsportapp/services/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CloudDataProvider extends ChangeNotifier {
  final BuildContext context;
  final User user;
  AllData data;

  List<Map<String, dynamic>> _sectionData;

  CloudDataProvider(context, {@required data, @required user})
      : this.context = context,
        this.user = user {
    this._sectionData = [];
    this.data = data;
  }

  // GETTERS
  get sectionData => _sectionData;

  // pulls new data from database
  Future<void> refreshData() async {
    data = await DatabaseService.getAllUserData(user: user);
  }

  // returns the data necessary to build the ToDo page
  ToDoData getToDoData() {
    return ToDoData();
  }

  // returns the data necessary to build the calendar page
  CalendarData getCalendarData() {
    return CalendarData();
  }

  // returns the data necessary to build the team page
  TeamData getTeamData() {
    return TeamData();
  }

  void newSectionData(List<Map<String, dynamic>> data) {
    this._sectionData = data;
  }
}
