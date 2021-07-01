import 'package:bcnemotorsportapp/models/AllData.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static Stream<QuerySnapshot> dbIdStream(String email) {
    return FirebaseFirestore.instance.collection('whitelist').where('email', isEqualTo: email).limit(1).snapshots();
  }
  
  static Stream<QuerySnapshot> sectionsStream() {
    return FirebaseFirestore.instance.collection('sections').orderBy('name').snapshots();
  }

  static Stream<QuerySnapshot> personsStream() {
    return FirebaseFirestore.instance.collection('users').orderBy('name').snapshots();
  }

  static Stream<QuerySnapshot> toDoStream() {
    return FirebaseFirestore.instance.collection('sections').orderBy('name').snapshots();
  }

  static Stream<QuerySnapshot> calendarStream(List<String> sectionIds) {
    return FirebaseFirestore.instance.collection('calendar').where('sectionIds', arrayContainsAny: sectionIds).snapshots();
  }

  // ########## UPDATES ##########

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
}
