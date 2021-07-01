import 'package:flutter/material.dart';

class Event {
  static const int _intensity = 400;
  static const int _defColorIndex = 6;
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

  String _name;
  bool _allDay;
  bool _global;
  Color _color;
  String _note;
  DateTime _from, _to;
  List<String> _sectionIds;

  Event({@required String name, @required bool allDay, @required bool global, @required Color color, @required DateTime from, @required DateTime to, List<String> sectionIds = const [], String note}) {
    _name = name;
    _allDay = allDay;
    _global = global;
    _color = color;
    _from = from;
    _to = to;
    _sectionIds = sectionIds;
    _note = note;
  }

  Event.fromRaw(Map<String, dynamic> data) {
    _name = data['name'];
    _allDay = data['allDay'];
    _global = data['global'];
    _from = DateTime.tryParse(data['from'].toDate().toString());
    _to = DateTime.tryParse(data['to'].toDate().toString());
    _color = colorFromInt(data['color']);
    _note = data['note'];
    _sectionIds = new List<String>.from(data['sectionIds'] ?? []);
  }

  String get name => _name;
  bool get allDay => _allDay;
  bool get global => _global;
  Color get color => _color;
  String get note => _note;
  DateTime get from => _from;
  DateTime get to => _to;
  List<String> get sectionIds => _sectionIds;

  Color colorFromInt(int n) {
    if (n >= colorList.length || n < 0) return colorList[_defColorIndex];
    return colorList[n];
  }

  int intFromColor(Color c) {
    int n = colorList.indexOf(c);
    if (n == -1) n = _defColorIndex;
    return n;
  }
}
