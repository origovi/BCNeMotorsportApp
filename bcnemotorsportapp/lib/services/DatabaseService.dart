import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  // checks if this user is in the database, as it means that it was
  // previously allowed by someone (i.e. TL) and can enter the system
  // returns the database user id
  static Future<bool> isEmailAuthorized(String email) async {
    print(email);
    var result = await FirebaseFirestore.instance
        .collection('whitelist')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return result.size >= 1;
  }


  // ########## STREAMS ##########

  static Stream<QuerySnapshot> versionStream() {
    return FirebaseFirestore.instance.collection('version').limit(1).snapshots();
  }

  static Stream<QuerySnapshot> dbIdStream(String email) {
    return FirebaseFirestore.instance.collection('whitelist').where('email', isEqualTo: email).limit(1).snapshots();
  }
  
  static Stream<QuerySnapshot> sectionsStream() {
    return FirebaseFirestore.instance.collection('sections').orderBy('name').snapshots();
  }

  static Stream<QuerySnapshot> personsStream() {
    return FirebaseFirestore.instance.collection('users').orderBy('name').snapshots();
  }

  static Stream<QuerySnapshot> toDoStream(List<String> sectionCompanyIds) {
    return FirebaseFirestore.instance.collection('todos').where('personIds', arrayContainsAny: sectionCompanyIds).snapshots();
  }

  static Stream<QuerySnapshot> calendarStream({@required bool global, bool isTeamLeader = false, List<String> sectionIds = const []}) {
    if (global) return FirebaseFirestore.instance.collection('calendar').where('global', isEqualTo: true).snapshots();
    else {
      if (isTeamLeader) return FirebaseFirestore.instance.collection('calendar').where('global', isEqualTo: false).snapshots();
      else return FirebaseFirestore.instance.collection('calendar').where('sectionId', whereIn: sectionIds).snapshots();
    }
  }

  static Stream<QuerySnapshot> announcementsStream({@required bool global, bool isTeamLeader = false, List<String> sectionIds = const []}) {
    if (global) return FirebaseFirestore.instance.collection('announcements').where('global', isEqualTo: true).snapshots();
    else {
      if (isTeamLeader) return FirebaseFirestore.instance.collection('announcements').where('global', isEqualTo: false).snapshots();
      else return FirebaseFirestore.instance.collection('announcements').where('sectionId', whereIn: sectionIds).snapshots();
    }
  }


  // ########## UPDATES ##########

  static Future<void> updateUserFcmToken(String dbId, String newToken) async {
    await FirebaseFirestore.instance.collection('users').doc(dbId).update({'fcmToken': newToken});
  }

  static Future<void> updateSectionAbout(String sectionId, String newAbout) async {
    await FirebaseFirestore.instance.collection('sections').doc(sectionId).update({'about': newAbout, 'hasAbout': newAbout.isNotEmpty});
  }

  static Future<void> updatePersonAbout(String dbId, String newAbout) async {
    await FirebaseFirestore.instance.collection('users').doc(dbId).update({'about': newAbout, 'hasAbout': newAbout.isNotEmpty});
  }

  static Future<void> updatePersonSections(String dbId, Map<String, dynamic> sections) async {
    await FirebaseFirestore.instance.collection('users').doc(dbId).update({'sections': sections});
  }
  
  static Future<void> updateSectionMembers(String sectionId, List<Pair<String, Map>> userSections, List<String> sectionMembers, List<String> sectionChiefs) async {
    // Add members to section
    await FirebaseFirestore.instance.collection('sections').doc(sectionId).update({'members': sectionMembers, 'chiefs': sectionChiefs});
    
    // Add section, role and chief to user
    for (Pair<String, Map> userSection in userSections) {
      await FirebaseFirestore.instance.collection('users').doc(userSection.first).update({'sections': userSection.second});
    }
  }

  static Future<List<String>> updateAppAccess(List<Map<String, dynamic>> addList, List<Pair<String, List<Map<String, dynamic>>>> removeListIds) async {
    List<String> newDbIds = [];
    // Add new members
    for (var newMemberData in addList) {
      String dbId = (await FirebaseFirestore.instance.collection('whitelist').add({'email': newMemberData['email']})).id;
      newDbIds.add(dbId);
      newMemberData['dbId'] = dbId;
      await FirebaseFirestore.instance.collection('users').doc(dbId).set(newMemberData);
    }
    
    // Remove members
    for (Pair<String, List<Map<String, dynamic>>> memberToBeRemoved in removeListIds) {
      await FirebaseFirestore.instance.collection('whitelist').doc(memberToBeRemoved.first).delete();
      for (Map<String, dynamic> sectionInfo in memberToBeRemoved.second) {
        await FirebaseFirestore.instance.collection('sections').doc(sectionInfo['sectionId']).update(sectionInfo);
      }
      await FirebaseFirestore.instance.collection('users').doc(memberToBeRemoved.first).delete();

      // maybe more data to be deleted
      // TODO
    }
    return newDbIds;
  }

  static Future<List<String>> updateSections(List<Map<String, dynamic>> addList, List<Pair<String, List<String>>> removeList) async {
    List<String> newDbIds = [];
    // Add new sections
    for (var newSectionData in addList) {
      newDbIds.add((await FirebaseFirestore.instance.collection('sections').add(newSectionData)).id);
    }
    
    // Remove sections
    for (Pair<String, List<String>> sectionToBeRemoved in removeList) {
      for (String sectionMember in sectionToBeRemoved.second) {
        Map<String, dynamic> memberSections = (await FirebaseFirestore.instance.collection('users').doc(sectionMember).get()).data()['sections'];
        memberSections.remove(sectionToBeRemoved.first);
        await FirebaseFirestore.instance.collection('users').doc(sectionMember).update({'sections': memberSections});

      }
      
      await FirebaseFirestore.instance.collection('sections').doc(sectionToBeRemoved.first).delete();

      // maybe more data to be deleted
      // TODO
    }
    return newDbIds;

  }

  static Future<void> updateToDo(String id, Map<String, dynamic> dataToUpdate) async {
    await FirebaseFirestore.instance.collection('todos').doc(id).update(dataToUpdate);
  }

  static Future<void> updateToDosCompleted(String dbId, int numToDosCompleted) async {
    await FirebaseFirestore.instance.collection('users').doc(dbId).update({'toDosCompleted': numToDosCompleted});
  }


  // ########## NEW ##########

  static Future<String> newEvent(Map<String, dynamic> event) async {
    return (await FirebaseFirestore.instance.collection('calendar').add(event)).id;
  }

  static Future<String> newAnnouncement(Map<String, dynamic> announcement) async {
    return (await FirebaseFirestore.instance.collection('announcements').add(announcement)).id;
  }

  static Future<String> newToDo(Map<String, dynamic> toDo) async {
    return (await FirebaseFirestore.instance.collection('todos').add(toDo)).id;
  }


  // ########## DELETE ##########
  static Future<void> deleteEvent(String eventId) async {
    await FirebaseFirestore.instance.collection('calendar').doc(eventId).delete();
  }

  static Future<void> deleteAnnouncement(String announcementId) async {
    await FirebaseFirestore.instance.collection('announcements').doc(announcementId).delete();
  }

  static Future<void> deleteToDo(String toDoId) async {
    await FirebaseFirestore.instance.collection('todos').doc(toDoId).delete();
  }
}
