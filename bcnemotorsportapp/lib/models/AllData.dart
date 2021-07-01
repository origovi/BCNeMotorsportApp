import 'package:bcnemotorsportapp/models/calendar/CalendarData.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/team/PersonsData.dart';
import 'package:bcnemotorsportapp/models/team/SectionsData.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDoAllData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllData {
  ToDoAllData _toDoAllData;
  SectionsData _sectionsData;
  PersonsData _personsData;
  CalendarData _calendarData;

  // CONSTRUCTORS
  AllData({@required SectionsData sectionsData, @required PersonsData personsData, @required CalendarData calendarData}) {
    _sectionsData = sectionsData;
    _personsData = personsData;
    _calendarData = calendarData;
  }

  AllData.fromDatabase({@required QuerySnapshot sectionsData, @required QuerySnapshot personsData, @required QuerySnapshot calendarData})
      : this(
          sectionsData: SectionsData.fromDatabase(sectionsData),
          personsData: PersonsData.fromDatabase(personsData),
          calendarData: CalendarData.fromDatabase(calendarData)
        );

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
  Map<String, dynamic> personSections(String dbId) => _personsData.personSections(dbId);

  List<Person> personsThatCoincideCompleteName(String text, {@required List<Person> exclude}) {
    return _personsData.personsThatCoincideCompleteName(text, exclude: exclude);
  }

  // NEW DATA
  void newSectionsData(QuerySnapshot data) {
    _sectionsData = SectionsData.fromDatabase(data);
  }

  void newCalendarData(QuerySnapshot data) {
    _calendarData = CalendarData.fromDatabase(data);
  }
}
