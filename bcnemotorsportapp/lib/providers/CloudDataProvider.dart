import 'package:bcnemotorsportapp/models/AllData.dart';
import 'package:bcnemotorsportapp/models/CalendarData.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/team/SectionsData.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDoData.dart';
import 'package:bcnemotorsportapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CloudDataProvider extends ChangeNotifier {
  final BuildContext _context;
  AllData _data;
  User _user;
  String _dbUId;

  CloudDataProvider(this._context);

  void init({@required data, @required user, @required dbUId}) {
    this._data = data;
    this._user = user;
    this._dbUId = dbUId;
  }

  // GETTERS
  SectionsData get sectionsData => _data.sectionsData;
  String get dbUId => _dbUId;

  // pulls new data from database
  Future<void> refreshData() async {
    _data = await DatabaseService.getAllUserData(user: _user);
  }

  Person personById(String id) {
    return _data.personById(id);
  }

  Person get user => personById(_dbUId);

  // returns the data necessary to build the ToDo page
  ToDoData getToDoData() {
    return ToDoData();
  }

  // returns the data necessary to build the calendar page
  CalendarData getCalendarData() {
    return CalendarData();
  }

  SectionsData newSectionsData(QuerySnapshot newSectionsData) {
    _data.newSectionsData(newSectionsData);
    return _data.sectionsData;
  }
}
