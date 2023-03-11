import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<String> createNewUser(
      Map<String, dynamic>? userData, String Uid,BuildContext context) async {
    if (userData != null) {
      await _preferenceService.init();
      await _preferenceService.setUserEmail(Uid);
      try {
        var querySnapshot = await _firestore
            .collection("users")
            .where('email', isEqualTo: Uid)
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
              .doc(Uid)
              .set(userData, SetOptions(merge: true));
        }
        print("your user data is $userData");
      } on Exception catch (e) {
        log('Exception $e');
      }
    }
    return Uid;
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
}
