import 'package:bcnemotorsportapp/models/AllData.dart';
import 'package:bcnemotorsportapp/models/calendar/Announcement.dart';
import 'package:bcnemotorsportapp/models/calendar/CalendarData.dart';
import 'package:bcnemotorsportapp/models/calendar/Event.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:bcnemotorsportapp/models/team/SectionsData.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDoData.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/services/DatabaseService.dart';
import 'package:bcnemotorsportapp/services/MessagingService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CloudDataProvider extends ChangeNotifier {
  BuildContext _context;
  AllData _data;
  User _user;
  String _dbUId;

  CloudDataProvider();

  void init({@required AllData data, @required User user, @required String dbId}) {
    this._data = data;
    this._user = user;
    this._dbUId = dbId;
    //notifyListeners();
  }

  void setContext(BuildContext context) => _context = context;

  // GETTERS
  BuildContext get context => _context;
  bool get allDataNull => _data == null;
  SectionsData get sectionsData => _data.sectionsData;
  CalendarData get calendarData => _data.calendarData;
  ToDoData get toDoData => _data.toDoData;
  String get dbUId => _dbUId;
  bool get isTeamLeader => personById(_dbUId).isTeamLeader;
  bool get isChief => personById(_dbUId).chiefSectionIds.isNotEmpty;

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

  List<Section> get allSections => sectionsData.dataList;
  List<Section> get userSections =>
      user.memberSectionIds.map((e) => _data.sectionsData.sectionById(e)).toList();
  List<Section> get userChiefSections =>
      user.chiefSectionIds.map((e) => _data.sectionsData.sectionById(e)).toList();

  // UPDATES
  Future<bool> updateUserFcmToken() async {
    String actualFcmToken = await MessagingService.getToken();
    if (user.fcmToken == null || user.fcmToken != actualFcmToken) {
      user.setFcmToken(actualFcmToken);
      await DatabaseService.updateUserFcmToken(_dbUId, actualFcmToken);
      return true;
    }
    return false;
  }

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
        memberIds.removeWhere((element) => element == personToBeRemoved.dbId);
        sectionInfo['members'] = memberIds;
        thisPersonSections.add(sectionInfo);
      });

      // iterate the sections where he is only chief
      personToBeRemoved.chiefSectionIds.forEach((chiefSectionId) {
        Map<String, dynamic> sectionInfo = {};
        sectionInfo['sectionId'] = chiefSectionId;
        List<String> chiefIds = sectionById(chiefSectionId).chiefIds;
        // remove the chief from the list
        chiefIds.removeWhere((element) => element == personToBeRemoved.dbId);
        sectionInfo['chiefs'] = chiefIds;

        List<String> memberIds = sectionById(chiefSectionId).memberIds;
        // remove the member from the list
        memberIds.removeWhere((element) => element == personToBeRemoved.dbId);
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

  Future<void> completeToDo(String id) async {
    toDoData.completeToDo(id);
    await DatabaseService.updateToDo(id, {'done': true});
  }

  Future<void> incompleteToDo(String id) async {
    toDoData.incompleteToDo(id);
    await DatabaseService.updateToDo(id, {'done': false});
  }

  // ADD NEW
  Future<String> newEvent(Event newEvent) async {
    String newEventId = await DatabaseService.newEvent(newEvent.toRaw());
    newEvent.addId(newEventId);
    calendarData.addEvent(newEvent);
    return newEventId;
  }

  Future<String> newAnnouncement(Announcement newAnnouncement) async {
    String newAnnouncementId = await DatabaseService.newAnnouncement(newAnnouncement.toRaw());
    newAnnouncement.addId(newAnnouncementId);
    calendarData.addAnnouncement(newAnnouncement);
    return newAnnouncementId;
  }

  Future<String> newToDo(ToDo newToDo) async {
    String newToDoId = await DatabaseService.newToDo(newToDo.toRaw());
    newToDo.addId(newToDoId);
    toDoData.addToDo(newToDo);
    return newToDoId;
  }

  // DELETE
  Future<void> deleteEvent(String eventId) async {
    calendarData.deleteEvent(eventId);
    await DatabaseService.deleteEvent(eventId);
  }

  Future<void> deleteAnnouncement(String announcementId) async {
    calendarData.deleteAnnouncement(announcementId);
    await DatabaseService.deleteAnnouncement(announcementId);
  }

  // OTHERS
  List<Person> personsThatCoincideCompleteName(String text, {@required List<Person> exclude}) =>
      _data.personsThatCoincideCompleteName(text, exclude: exclude);

  bool existsPersonWithEmail(String email) => _data.personsData.existsPersonWithEmail(email);
}
