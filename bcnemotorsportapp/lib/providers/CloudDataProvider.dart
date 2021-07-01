import 'package:bcnemotorsportapp/models/AllData.dart';
import 'package:bcnemotorsportapp/models/calendar/CalendarData.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:bcnemotorsportapp/models/team/SectionsData.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDoData.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CloudDataProvider extends ChangeNotifier {
  final BuildContext _context;
  AllData _data;
  User _user;
  String _dbId;

  CloudDataProvider(this._context);

  void init(bool first, {@required AllData data, @required User user, @required String dbId}) {
    this._data = data;
    this._user = user;
    this._dbId = dbId;
    //notifyListeners();
  }

  // GETTERS
  SectionsData get sectionsData => _data.sectionsData;
  CalendarData get calendarData => _data.calendarData;
  String get dbUId => _dbId;
  bool get isTeamLeader => personById(_dbId).isTeamLeader;
  bool get isChief => personById(_dbId).chiefSectionIds.isNotEmpty;

  // pulls new data from database
  Future<void> refreshData() async {
    //_data = await DatabaseService.getAllUserData(user: _user);
  }

  Person personById(String id) {
    return _data.personById(id);
  }

  Section sectionById(String id) {
    return _data.sectionsData.sectionById(id);
  }

  List<Person> get personList => _data.personsData.dataList;

  Person get user => personById(dbUId);

  // returns the data necessary to build the ToDo page
  ToDoData getToDoData() {
    return ToDoData();
  }

  // returns the data necessary to build the calendar page
  CalendarData getCalendarData() {
    return null;
  }

  SectionsData newSectionsData(QuerySnapshot newSectionsData) {
    _data.newSectionsData(newSectionsData);
    print("NEW SECTIONS DATA");
    return _data.sectionsData;
  }

  CalendarData newCalendarData(QuerySnapshot newCalendarData) {
    _data.newCalendarData(newCalendarData);
    print("NEW CALENDAR DATA");
    return _data.calendarData;
  }

  // UPDATES
  Future<void> updateSectionAbout(String sectionId, String newAbout) async {
    await DatabaseService.updateSectionAbout(sectionId, newAbout);
  }

  Future<void> updatePersonAbout(String dbId, String newAbout) async {
    await DatabaseService.updatePersonAbout(dbId, newAbout);
  }

  Future<void> updatePersonRoleInSection(String dbId, String sectionId, String newRole) async {
    Map<String, dynamic> aux = _data.personSections(dbId);
    aux[sectionId]['role'] = newRole;
    await DatabaseService.updatePersonSections(dbId, aux);
  }

  Future<void> updateSectionMembers(
      {@required String sectionId,
      List<String> add,
      List<String> remove,
      bool chief = false}) async {
    assert(add != null || remove != null);

    List<Pair<String, Map>> userSections = [];
    add.forEach((element) {
      Map<String, Map<String, dynamic>> userSection =
          _data.personsData.personById(element).sections;
      var sectionInfo = {'chief': chief, 'role': ""};
      userSection[sectionId] = sectionInfo;
      userSections.add(Pair(element, userSection));
    });
    remove.forEach((element) {
      Map<String, Map<String, dynamic>> userSection =
          _data.personsData.personById(element).sections;
      // if chief, maintain him as a member
      if (!chief)
        userSection.removeWhere((key, value) => key == sectionId);
      else
        userSection[sectionId]['chief'] = false;
      userSections.add(Pair(element, userSection));
    });

    List<String> sectionMembers = _data.sectionsData.sectionById(sectionId).memberIds;
    sectionMembers.removeWhere((element) => remove.contains(element));
    add.forEach((element) {
      if (!sectionMembers.contains(element)) {
        sectionMembers.add(element);
      }
    });
    List<String> sectionChiefs = _data.sectionsData.sectionById(sectionId).chiefIds;
    if (chief) {
      sectionChiefs.removeWhere((element) {
        if (remove.contains(element)) {
          // if he was a chief, maintain him as a member
          sectionMembers.add(element);
          return true;
        } else
          return false;
      });
      add.forEach((element) {
        if (!sectionChiefs.contains(element)) sectionChiefs.add(element);
      });
    }

    await DatabaseService.updateSectionMembers(
        sectionId, userSections, sectionMembers, sectionChiefs);
  }

  Future<void> updateAppAccess(List<Person> addPersonList, List<Person> removePersonList) async {
    List<Map<String, dynamic>> addList = [];
    // for each id,    a list of sctionIds (including members and chiefs to update)
    List<Pair<String, List<Map<String, dynamic>>>> removeListIds = [];

    addPersonList.forEach((element) {
      addList.add(element.toRaw());
    });

    removePersonList.forEach((personToBeRemoved) {
      //   dbId,     user sections
      List<Map<String, dynamic>> thisPersonSections = [];
      
      // iterate the sections where he is only member
      personToBeRemoved.onlyMemberSectionIds.forEach((onlyMemberSectionId) {
        Map<String, dynamic> sectionInfo = {};
        sectionInfo['sectionId'] = onlyMemberSectionId;
        List<String> memberIds = sectionById(onlyMemberSectionId).memberIds;
        // remove the member from the list
        memberIds.removeWhere((element) => element==personToBeRemoved.dbId);
        sectionInfo['members'] = memberIds;
        thisPersonSections.add(sectionInfo);
      });

      // iterate the sections where he is only chief
      personToBeRemoved.chiefSectionIds.forEach((chiefSectionId) {
        Map<String, dynamic> sectionInfo = {};
        sectionInfo['sectionId'] = chiefSectionId;
        List<String> chiefIds = sectionById(chiefSectionId).chiefIds;
        // remove the chief from the list
        chiefIds.removeWhere((element) => element==personToBeRemoved.dbId);
        sectionInfo['chiefs'] = chiefIds;

        List<String> memberIds = sectionById(chiefSectionId).memberIds;
        // remove the member from the list
        memberIds.removeWhere((element) => element==personToBeRemoved.dbId);
        sectionInfo['members'] = memberIds;
        thisPersonSections.add(sectionInfo);
      });

      // remove Person from local storage
      _data.personsData.data.remove(personToBeRemoved.dbId);

      removeListIds.add(Pair(personToBeRemoved.dbId, thisPersonSections));
    });

    // update local info
    List<String> newIds = await DatabaseService.updateAppAccess(addList, removeListIds);
    for (var i = 0; i < newIds.length; i++) {
      addPersonList[i].setDbId(newIds[i]);
      _data.personsData.data[newIds[i]] = addPersonList[i];
    }
    
  }

  // OTHERS
  List<Person> personsThatCoincideCompleteName(String text, {@required List<Person> exclude}) =>
      _data.personsThatCoincideCompleteName(text, exclude: exclude);

  bool existsPersonWithEmail(String email) => _data.personsData.existsPersonWithEmail(email);
}
