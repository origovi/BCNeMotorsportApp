import 'package:bcnemotorsportapp/models/AllData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  // checks if this user is in the database, as it means that it was
  // previously allowed by someone (i.e. TL) and can enter the system
  static Future<bool> isAValidUserMail(String email) async {
    var result = await FirebaseFirestore.instance
        .collection('whitelist')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return result.size >= 1;
  }

  static Future<AllData> getAllUserData({@required User user}) async {
    var teamData = await FirebaseFirestore.instance
        .collection('sections').orderBy('name').get();
    await Future.delayed(Duration(seconds: 2));
    return AllData();
  }

  static Stream<QuerySnapshot> teamStream() {
    return FirebaseFirestore.instance.collection('sections').orderBy('name').snapshots();
  }

  static Stream<QuerySnapshot> toDoStream() {
    return FirebaseFirestore.instance.collection('sections').orderBy('name').snapshots();
  }
}
