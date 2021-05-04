import 'package:bcnemotorsportapp/models/AllData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  // checks if this user is in the database, as it means that it was
  // previously allowed by someone (i.e. TL) and can enter the system
  // returns the database user id
  static Future<bool> isEmailAuthorized(String email) async {
    var result = await FirebaseFirestore.instance
        .collection('whitelist')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return result.size >= 1;
  }

  static Future<AllData> getAllUserData({@required User user}) async {
    var sectionsData = await FirebaseFirestore.instance.collection('sections').orderBy('name').get();
    var personsData = await FirebaseFirestore.instance.collection('users').orderBy('surname').get();
    var dbIdData = await FirebaseFirestore.instance.collection('whitelist').where('email', isEqualTo: user.email).limit(1).get();
    await Future.delayed(Duration(seconds: 2));
    return AllData.fromDatabase(dbId: dbIdData.docs[0].data()['dbId'], sectionsData: sectionsData, personsData: personsData);
  }

  static Stream<QuerySnapshot> teamStream() {
    return FirebaseFirestore.instance.collection('sections').orderBy('name').snapshots();
  }

  static Stream<QuerySnapshot> toDoStream() {
    return FirebaseFirestore.instance.collection('sections').orderBy('name').snapshots();
  }

  static Future<void> updateSectionAbout(String sectionId, String newAbout) async {
    FirebaseFirestore.instance.collection('sections').doc(sectionId).update({'about': newAbout, 'hasAbout': newAbout.isNotEmpty});
  }

  static Future<void> updatePersonAbout(String dbId, String newAbout) async {
    FirebaseFirestore.instance.collection('users').doc(dbId).update({'about': newAbout, 'hasAbout': newAbout.isNotEmpty});
  }
}
