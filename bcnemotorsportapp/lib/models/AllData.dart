import 'package:bcnemotorsportapp/models/calendar/CalendarData.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/team/PersonsData.dart';
import 'package:bcnemotorsportapp/models/team/SectionsData.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDoData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllData {
  String _dbId;
  ToDoData _toDoData;
  SectionsData _sectionsData;
  PersonsData _personsData;
  CalendarData _calendarData;

  // CONSTRUCTORS
  AllData(
      {@required String dbId,
      @required SectionsData sectionsData,
      @required PersonsData personsData,
      @required ToDoData toDoData,
      @required CalendarData calendarData}) {
    _dbId = dbId;
    _sectionsData = sectionsData;
    _personsData = personsData;
    _toDoData = toDoData;
    _calendarData = calendarData;
  }

  AllData.fromDatabase(
      {@required String dbId,
      @required QuerySnapshot sectionsData,
      @required QuerySnapshot personsData,
      @required QuerySnapshot toDoData,
      @required List<QueryDocumentSnapshot> eventData,
      @required List<QueryDocumentSnapshot> announcementData})
      : this(
          dbId: dbId,
          sectionsData: SectionsData.fromDatabase(sectionsData),
          personsData: PersonsData.fromDatabase(personsData),
          toDoData: ToDoData.fromDatabase(toDoData, dbId),
          calendarData: CalendarData.fromDatabase(eventData, announcementData),
        );

  // AllData.fromRaw({@required sectionsData, @required personsData}) {
  //   _sectionsData = SectionsData.fromRaw(sectionsData);
  //   _personsData = PersonsData.fromRaw(personsData);
  // }

  // GETTERS
  CalendarData get calendarData => _calendarData;

  ToDoData get toDoData => _toDoData;

  SectionsData get sectionsData => _sectionsData;

  PersonsData get personsData => _personsData;
  Person personById(String id) => _personsData.personById(id);

  Person personByIndex(int index) => _personsData.personByIndex(index);
  Map<String, dynamic> personSections(String dbId) => _personsData.personSections(dbId);

  List<Person> personsThatCoincideCompleteName(String text, {@required List<Person> exclude}) {
    return _personsData.personsThatCoincideCompleteName(text, exclude: exclude);
  }
}
