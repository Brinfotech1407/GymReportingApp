import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gim_app/models/gym_details.dart';
import 'package:gim_app/models/user.dart';
import 'package:gim_app/services/notification_service.dart';
import 'package:gim_app/services/preference_service.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PreferenceService _preferenceService = PreferenceService();
  NotificationServices notificationServices = NotificationServices();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> createNewUser(
      UserModel userData, BuildContext context) async {
    await _preferenceService.init();
    await _preferenceService.setUserEmail(userData.email!);
    try {
      var querySnapshot = await _firestore
          .collection("users")
          .where('email', isEqualTo: userData.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Email already exists, show error message
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: '',
          text: 'Email already exists.',
        );
        throw "Email already exists";
      } else {
        // Add user data to Firestore
        await _firestore
            .collection("users")
            .doc(userData.email)
            .set(userData.toJson(), SetOptions(merge: true));

        if (userData.email != null && userData.password != null) {
          await auth.createUserWithEmailAndPassword(
              email: userData.email!, password: userData.password!);
        }
      }
    } on Exception catch (e) {
      log('Exception $e');
    }
    return userData.email;
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('users').doc(uid).get();
      final UserModel user = UserModel.fromJson(doc.data()!);
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String?> createGymDetails(
      GymDetailsModel gymData, BuildContext context) async {
    try {
      // Add user data to Firestore
      await _firestore
          .collection("gym")
          .doc(gymData.id)
          .set(gymData.toJson(), SetOptions(merge: true));

      //TODO : find user first, updated gym Details

      final snapshot = await _firestore.collection('users').get();

      final userDoc = snapshot.docs.last;
      UserModel user = UserModel.fromJson(userDoc.data());
      user.isGymDetailsFilled = true;

      await _firestore
          .collection('users')
          .doc(user.email)
          .update({'isGymDetailsFilled': true});

      print('isGymDetailsFilled ${user.isGymDetailsFilled}');

      _preferenceService.setBool(PreferenceService.ownerGymDetailsFiled, true);
    } on Exception catch (e) {
      log('Exception $e');
    }
    return gymData.id;
  }
}
