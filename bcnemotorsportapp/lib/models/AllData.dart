import 'package:bcnemotorsportapp/models/CalendarData.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/team/PersonsData.dart';
import 'package:bcnemotorsportapp/models/team/SectionsData.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDoAllData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllData {
  CalendarData _calendarData;
  ToDoAllData _toDoAllData;
  SectionsData _sectionsData;
  PersonsData _personsData;

  // CONSTRUCTORS
  AllData({@required SectionsData sectionsData, @required PersonsData personsData}) {
    _sectionsData = sectionsData;
    _personsData = personsData;
  }

  AllData.fromDatabase({@required QuerySnapshot sectionsData, @required QuerySnapshot personsData})
      : this(
            sectionsData: SectionsData.fromDatabase(sectionsData),
            personsData: PersonsData.fromDatabase(personsData));
  
  // AllData.fromRaw({@required sectionsData, @required personsData}) {
  //   _sectionsData = SectionsData.fromRaw(sectionsData);
  //   _personsData = PersonsData.fromRaw(personsData);
  // }

  // GETTERS
  CalendarData get calendarData => _calendarData;

  ToDoAllData get toDoAllData => _toDoAllData;

  SectionsData get sectionsData => _sectionsData;

  PersonsData get personsData => _personsData;
  Person personById(String id) => _personsData.personById(id);

  Person personByIndex(int index) => _personsData.personByIndex(index);

  // NEW DATA
  void newSectionsData(QuerySnapshot data) {
    _sectionsData = SectionsData.fromDatabase(data);
  }
}
