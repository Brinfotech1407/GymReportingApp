import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gim_app/models/user.dart';
import 'package:gim_app/services/notification_service.dart';
import 'package:gim_app/services/preference_service.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PreferenceService _preferenceService = PreferenceService();
  NotificationServices notificationServices =NotificationServices();
  FirebaseAuth auth = FirebaseAuth.instance;


  Future<String> createNewUser(
      UserModel userData, String emailId,BuildContext context) async {
    await _preferenceService.init();
    await _preferenceService.setUserEmail(emailId);
    try {
      var querySnapshot = await _firestore
          .collection("users")
          .where('email', isEqualTo: emailId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Email already exists, show error message
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: '',
          text:
          'Email already exists.',
        );
        throw "Email already exists";
      } else {
        // Add user data to Firestore
        await _firestore
            .collection("users")
            .doc(emailId)
            .set(userData.toJson(), SetOptions(merge: true));

        if(userData.email !=null  && userData.password !=null) {
          await auth.createUserWithEmailAndPassword(
              email: userData.email!, password: userData.password!);
        }
      }
      print("your user data is $userData");
    } on Exception catch (e) {
      log('Exception $e');
    }
    return emailId;
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('users').doc(uid).get();
      final UserModel user = UserModel.fromJson(doc.data()!);
      print('get the userData $user');
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<String> createGymDetails(
      Map<String, dynamic>? gymData, String uid,BuildContext context) async {
    if (gymData != null) {
      try {
          // Add user data to Firestore
          await _firestore
              .collection("gym")
              .doc(uid)
              .set(gymData, SetOptions(merge: true));

        print("your user data is $gymData");
      } on Exception catch (e) {
        log('Exception $e');
      }
    }
    return uid;
  }
}
