import 'package:flutter/material.dart';

class ToDo {
  static const int _intensity = 400;
  static const int defImportanceIndex = 3;
  static List<Color> colorList = [
    Colors.red[_intensity],
    Colors.orange[_intensity],
    Colors.yellow[_intensity],
    Colors.green[_intensity],
  ];

  static const List<String> importanceNames = [
    "We are late (LOL)",
    "Fiu fiu",
    "Better now",
    "Chill",
  ];

  String _id;
  String _name;
  bool _hasDescription;
  String _description;
  List<String> _personIds;
  // IMPORTANCE LEVELS:
  // 0 -> We are late (LOL), 1 -> Fiu fiu, 2 -> Better now
  // 3 -> Chill, 4 -> If there is time
  int _importanceLevel;
  DateTime _whenAdded;
  bool _hasDeadline;
  DateTime _deadline;

  // CONSTRUCTORS
  ToDo({
    String id = "",
    @required String name,
    String description,
    @required List<String> personIds,
    int importanceLevel = 4,
    DateTime whenAdded,
    bool hasDeadline=false,
    DateTime deadline,
  })  : _id = id,
        _name = name,
        _hasDescription = description != null,
        _description = description,
        _personIds = personIds ?? [],
        _whenAdded = whenAdded ?? DateTime.now(),
        _hasDeadline = hasDeadline,
        _deadline = deadline;

  ToDo.fromRaw(Map<String, dynamic> data, {String id = ""}) {
    _id = id;
    _name = data['name'];
    _hasDescription = data['hasDescription'] ?? false;
    if (_hasDescription) _description = data['description'];
    _personIds = List<String>.from(data['personIds']);
    _importanceLevel = data['importanceLevel'] ?? 4;
    _whenAdded = DateTime.tryParse(data['whenAdded'].toDate().toString());
    _hasDeadline = data['hasDeadline'] ?? false;
    if (_hasDeadline) _deadline = DateTime.tryParse(data['deadline'].toDate().toString());
  }

  // GETTERS
  String get id => _id;
  String get name => _name;
  bool get hasDescription => _hasDescription;
  String get description => _description;
  List<String> get personIds => _personIds;
  int get importanceLevel => _importanceLevel;
  DateTime get whenAdded => _whenAdded;
  bool get hasDeadline => _hasDeadline;
  DateTime get deadline => _deadline;
}
