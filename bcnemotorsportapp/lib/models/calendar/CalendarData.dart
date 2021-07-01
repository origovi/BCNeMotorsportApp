import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:bcnemotorsportapp/models/calendar/Event.dart';

class CalendarData extends CalendarDataSource {
  CalendarData(List<Event> source) {
    appointments = source;
  }

  factory CalendarData.fromDatabase(QuerySnapshot snapshot) {
    Map<String, Map<String, dynamic>> aux = {};
    snapshot.docs.forEach((element) => aux[element.id] = element.data());
    return new CalendarData.fromRaw(aux);
  }

  CalendarData.fromRaw(Map<String, Map<String, dynamic>> data) {
    appointments = [];
    data.forEach((key, value) => appointments.add(Event.fromRaw(value)));
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].name;
  }

  @override
  Color getColor(int index) {
    return appointments[index].color;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].allDay;
  }
}
