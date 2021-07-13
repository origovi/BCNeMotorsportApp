import 'package:bcnemotorsportapp/models/calendar/CalendarData.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/team/PersonsData.dart';
import 'package:bcnemotorsportapp/models/team/SectionsData.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDoData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllData {
  ToDoData _toDoAllData;
  SectionsData _sectionsData;
  PersonsData _personsData;
  CalendarData _calendarData;

  // CONSTRUCTORS
  AllData({@required SectionsData sectionsData, @required PersonsData personsData, @required CalendarData calendarData}) {
    _sectionsData = sectionsData;
    _personsData = personsData;
    _calendarData = calendarData;
  }

  AllData.fromDatabase({@required QuerySnapshot sectionsData, @required QuerySnapshot personsData, @required List<QueryDocumentSnapshot> eventData, @required List<QueryDocumentSnapshot> announcementData})
      : this(
          sectionsData: SectionsData.fromDatabase(sectionsData),
          personsData: PersonsData.fromDatabase(personsData),
          calendarData: CalendarData.fromDatabase(eventData, announcementData),
        );

  // AllData.fromRaw({@required sectionsData, @required personsData}) {
  //   _sectionsData = SectionsData.fromRaw(sectionsData);
  //   _personsData = PersonsData.fromRaw(personsData);
  // }

  // GETTERS
  CalendarData get calendarData => _calendarData;

  ToDoData get toDoAllData => _toDoAllData;

  SectionsData get sectionsData => _sectionsData;

  PersonsData get personsData => _personsData;
  Person personById(String id) => _personsData.personById(id);

  Person personByIndex(int index) => _personsData.personByIndex(index);
  Map<String, dynamic> personSections(String dbId) => _personsData.personSections(dbId);

  List<Person> personsThatCoincideCompleteName(String text, {@required List<Person> exclude}) {
    return _personsData.personsThatCoincideCompleteName(text, exclude: exclude);
  }
}
