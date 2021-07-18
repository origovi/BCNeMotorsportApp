import 'package:cloud_firestore/cloud_firestore.dart';
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

  static List<Color> _deadlineProgressColorList = [
    Colors.red[_intensity+200],
    Colors.orange[_intensity+200],
    Colors.yellow[_intensity+200],
    Colors.green[_intensity+200],
  ];

  static const List<String> importanceNames = [
    "We are late (LOL)",
    "Fiu fiu",
    "Better now",
    "Chill",
  ];

  // ATTRIBUTES
  String _id;
  String _name;
  bool _done;
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
    bool done = false,
    String description,
    @required List<String> personIds,
    int importanceLevel = defImportanceIndex,
    DateTime whenAdded,
    bool hasDeadline = false,
    DateTime deadline,
  })  : _id = id,
        _name = name,
        _done = done,
        _hasDescription = description != null && description.isNotEmpty,
        _description = description,
        _personIds = personIds ?? [],
        _whenAdded = whenAdded ?? DateTime.now(),
        _importanceLevel = importanceLevel,
        _hasDeadline = hasDeadline,
        _deadline = deadline;

  ToDo.fromRaw(Map<String, dynamic> data, {String id = ""}) {
    _id = id;
    _name = data['name'];
    _done = data['done'] ?? false;
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
  bool get done => _done;
  bool get hasDescription => _hasDescription;
  String get description => _description;
  List<String> get personIds => _personIds;
  int get importanceLevel => _importanceLevel;
  DateTime get whenAdded => _whenAdded;
  bool get hasDeadline => _hasDeadline;
  DateTime get deadline => _deadline;
  Color get color => colorList[_importanceLevel];
  Color get deadlineProgressColor => _deadlineProgressColorList[_importanceLevel];
  double get deadlineProgress {
    if (!_hasDeadline)
      return 0.0;
    else {
      DateTime now = DateTime.now();
      if (now.isAfter(_deadline))
        return 1.0;
      else
        return (now.millisecondsSinceEpoch - _whenAdded.millisecondsSinceEpoch) /
            (_deadline.millisecondsSinceEpoch - _whenAdded.millisecondsSinceEpoch);
    }
  }

  // METHODS
  void addId(String newToDoId) => _id = newToDoId;

  void complete() => _done = true;
  void incomplete() => _done = false;

  Map<String, dynamic> toRaw() {
    Map<String, dynamic> res = {};
    res['name'] = _name;
    res['done'] = _done;
    res['hasDescription'] = _hasDescription;
    if (_hasDescription) res['description'] = _description;
    res['personIds'] = _personIds;
    res['importanceLevel'] = _importanceLevel;
    res['hasDeadline'] = _hasDeadline;
    if (_hasDeadline) res['deadline'] = Timestamp.fromDate(_deadline);
    res['whenAdded'] = Timestamp.fromDate(_whenAdded);
    return res;
  }
}
