import 'package:bcnemotorsportapp/models/calendar/Announcement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:bcnemotorsportapp/models/calendar/Event.dart';

class CalendarData extends CalendarDataSource {
  List<Event> _allAppointments;
  List<Announcement> _allAnnouncements, _announcements;
  
  List<String> _selectedSectionIds;
  bool _global;
  CalendarData(List<Event> eventSource) {
    appointments = eventSource;
    _allAppointments = appointments;
    _global = true;
  }

  factory CalendarData.fromDatabase(List<QueryDocumentSnapshot> eventsSnapshot, List<QueryDocumentSnapshot> announcementsSnapshot) {
    Map<String, Map<String, dynamic>> eventsAux = {};
    Map<String, Map<String, dynamic>> announcementsAux = {};
    eventsSnapshot.forEach((element) => eventsAux[element.id] = element.data());
    announcementsSnapshot.forEach((element) => announcementsAux[element.id] = element.data());
    return new CalendarData.fromRaw(eventsAux, announcementsAux);
  }

  CalendarData.fromRaw(Map<String, Map<String, dynamic>> eventsData, Map<String, Map<String, dynamic>> announcementsData) {
    _allAppointments = [];
    _allAnnouncements = [];
    eventsData.forEach((key, value) => _allAppointments.add(Event.fromRaw(value, id: key)));
    appointments = _allAppointments;
    announcementsData.forEach((key, value) => _allAnnouncements.add(Announcement.fromRaw(value, announcementId: key)));
    _announcements = _allAnnouncements;
    _announcements.sort((a1, a2) => a1.whenAdded.isBefore(a2.whenAdded) ? 1 : 0);
  }

  bool get global => _global;
  List<String> get selectedSectionIds => _selectedSectionIds;
  List<Announcement> get announcements => _announcements;

  void filterCalendar({bool global, List<String> sectionIds}) {
    assert(
        global != null || sectionIds != null, "Impossible to call function without any argument");
    if (global != null) _global = global;
    if (sectionIds != null) _selectedSectionIds = sectionIds;
    appointments = List<Event>.from(_allAppointments);
    appointments.removeWhere((element) {
      if (_global && element.global) return false;
      if (!element.global && _selectedSectionIds.contains(element.sectionId)) return false;
      return true;
    });
    _announcements = List<Announcement>.from(_allAnnouncements);
    _announcements.removeWhere((element) {
      if (_global && element.global) return false;
      if (!element.global && _selectedSectionIds.contains(element.sectionId)) return false;
      return true;
    });
  }

  void addEvent(Event e) {
    _allAppointments.add(e);
    if ((e.global && _global) || (!e.global && _selectedSectionIds.contains(e.sectionId)))
      this.appointments.add(e);
  }

  void addAnnouncement(Announcement a) {
    _allAnnouncements.add(a);
    if ((a.global && _global) || (!a.global && _selectedSectionIds.contains(a.sectionId))) {
      _announcements.add(a);
      _announcements.sort((a1, a2) => a1.whenAdded.isBefore(a2.whenAdded) ? 1 : 0);
    }
  }

  void deleteEvent(String eventId) {
    _allAppointments.removeWhere((element) => element.id == eventId);
    this.appointments.removeWhere((element) => element.id == eventId);
  }

  void deleteAnnouncement(String announcementId) {
    _allAnnouncements.removeWhere((element) => element.id == announcementId);
    this._announcements.removeWhere((element) => element.id == announcementId);
  }

  Event getEvent(String eventId) {
    for (Event event in _allAppointments) {
      if (event.id == eventId) return event;
    }
    return null;
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
