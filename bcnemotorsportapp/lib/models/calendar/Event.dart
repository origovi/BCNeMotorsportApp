import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  static const int _intensity = 300;
  static const int defColorIndex = 6;
  static List<Color> colorList = [
    Colors.red[_intensity],
    Colors.orange[_intensity],
    Colors.yellow[_intensity],
    Colors.green[_intensity],
    Colors.lightGreen[_intensity],
    Colors.teal[_intensity],
    Colors.blue[_intensity],
    Colors.purple[_intensity],
    Colors.brown[_intensity],
    Colors.grey[_intensity],
  ];

  static const List<String> colorNames = [
    "Red",
    "Orange",
    "Yellow",
    "Green",
    "Lime",
    "Teal",
    "Blue",
    "Purple",
    "Brown",
    "Grey",
  ];

  String _id;

  String _name;
  bool _allDay;
  bool _global;
  Color _color;
  String _note;
  DateTime _from, _to;
  String _sectionId;
  bool _hasNote;

  // CONSTRUCTORS
  Event(
      {String id = "",
      @required String name,
      @required bool allDay,
      @required bool global,
      @required Color color,
      @required DateTime from,
      @required DateTime to,
      String sectionId,
      String note})
      : _id = id,
        _name = name,
        _allDay = allDay,
        _global = global,
        _color = color,
        _from = from,
        _to = to,
        _sectionId = sectionId,
        _note = note,
        _hasNote = note != null && note.isNotEmpty;

  Event.fromRaw(Map<String, dynamic> data, {String id = ""}) {
    _id = id;
    _name = data['name'];
    _allDay = data['allDay'];
    _global = data['global'];
    _from = DateTime.tryParse(data['from'].toDate().toString());
    _to = DateTime.tryParse(data['to'].toDate().toString());
    _color = colorFromInt(data['color'] ?? defColorIndex);
    _note = data['note'];
    _sectionId = data['sectionId'];
    _hasNote = _note != null && _note.isNotEmpty;
  }

  // GETTERS
  String get id => _id;
  String get name => _name;
  bool get allDay => _allDay;
  bool get global => _global;
  Color get color => _color;
  String get note => _note;
  bool get hasNote => _hasNote;
  DateTime get from => _from;
  DateTime get to => _to;
  String get sectionId => _sectionId;

  // METHODS
  String get scheduleMessage {
    String res = "Scheduled ";
    final DateTime now = DateTime.now();
    // if the event is today
    if (_from.year == now.year && _from.month == now.month && _from.day == now.day) {
      res += "today";
    }
    else {
      res += "on ${formatEventDate(_from, year: _from.year != now.year)}";
    }
    if (!_allDay) res += " at ${formatEventTime(_from)}";
    return res;
  }

  Color colorFromInt(int n) {
    if (n >= colorList.length || n < 0) return colorList[defColorIndex];
    return colorList[n];
  }

  int intFromColor(Color c) {
    int n = colorList.indexOf(c);
    if (n == -1) n = defColorIndex;
    return n;
  }

  void addId(String id) {
    assert(_id == "", "Cannot add an id to an event that already has one");
    _id = id;
  }

  Map<String, dynamic> toRaw() {
    Map<String, dynamic> res = {};
    res['name'] = _name;
    res['allDay'] = _allDay;
    res['global'] = _global;
    res['from'] = Timestamp.fromDate(_from);
    res['to'] = Timestamp.fromDate(_to);
    res['color'] = intFromColor(_color);
    if (!global) res['sectionId'] = _sectionId;
    if (_hasNote) res['note'] = _note;
    return res;
  }
}
