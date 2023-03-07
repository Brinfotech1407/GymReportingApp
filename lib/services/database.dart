import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gim_app/models/user.dart';
import 'package:gim_app/services/preference_service.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PreferenceService _preferenceService = PreferenceService();


  Future<String> createNewUser(Map<String, dynamic>? userData,
      String Uid) async {
    if (userData != null) {
      await _preferenceService.init();
      await _preferenceService.setUserEmail(Uid);
      try {
        await _firestore.collection("users").doc(Uid).set(userData,
            SetOptions(
                merge: true
            ));
        print("your user data is $userData");
      } on Exception catch (e) {
        log('Exception $e');
      }
    }
    return Uid;
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final DocumentSnapshot <Map<String, dynamic>>doc =
      await _firestore.collection('users').doc(uid).get();
      final UserModel user = UserModel.fromJson(doc.data()!);
      print('get the userData $user');
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
