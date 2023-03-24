import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:gim_app/models/gym_details.dart';
import 'package:gim_app/models/gym_report_model.dart';
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

  RxList<DocumentSnapshot<Map<String, dynamic>>> myData =
      RxList<DocumentSnapshot<Map<String, dynamic>>>();

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
      final DocumentSnapshot<Map<String, dynamic>> doc = (await _firestore
          .collection('users')
          .where('id', isEqualTo: uid)
          .get()) as DocumentSnapshot<Map<String, dynamic>>;

      if (doc.exists) {
        final UserModel user = UserModel.fromJson(doc.data()!);
        return user;
      } else {
        return null;
      }
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

      //below code is get user and update the isGymDetailsFilled true

      var querySnapshot = await _firestore
          .collection("users")
          .where('id', isEqualTo: gymData.ownerId)
          .get();

      var userDocs = querySnapshot.docs;

      if (userDocs.isNotEmpty) {
        var userDocRef = userDocs.first.reference;

        await userDocRef.update({'isGymDetailsFilled': true});

        await _preferenceService.setBool(
            PreferenceService.ownerGymDetailsFiled, true);
      }
    } on Exception catch (e) {
      log('Exception $e');
    }
    return gymData.id;
  }

  Future<String?> createGymReport(
      GymReportModel gymReportData, BuildContext context) async {
    try {
      // Add user data to Firestore
      await _firestore
          .collection("gym_report")
          .doc(gymReportData.id)
          .set(gymReportData.toJson(), SetOptions(merge: true));
    } on Exception catch (e) {
      log('Exception $e');
    }
    return gymReportData.id;
  }

  Stream<List<GymReportModel>> fetchGymReport() {
    return  _firestore.collection('gym_report').snapshots().map((event) {
        return event.docs.map((e) =>  GymReportModel.fromJson(e.data())).toList();
      });
  }

  Future<GymReportModel?> getSingleGymReportData(String uid) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> doc = (await _firestore
          .collection('gym_report')
          .where('userId', isEqualTo: uid)
          .get());

      if (doc.docs.isNotEmpty) {
        final GymReportModel user =
            GymReportModel.fromJson(doc.docs.first.data());
        return user;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<GymDetailsModel?> isGymPresent(String uid) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> doc = (await _firestore
          .collection('gym')
          .where('id', isEqualTo: uid)
          .get());

      if (doc.docs.isNotEmpty) {
        final GymDetailsModel gymDetailsModel =
            GymDetailsModel.fromJson(doc.docs.first.data());
        return gymDetailsModel;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<int> checkUserAlreadySignedIn(
    String uid,
    String gymID,
    String currentDate,
  ) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> doc = (await _firestore
          .collection('gym_report')
          .where('userId', isEqualTo: uid)
          .where('gymId', isEqualTo: gymID)
          .where('date', isEqualTo: currentDate)
          .get());

      if (doc.docs.isNotEmpty) {
        final GymReportModel gymReportModel =
            GymReportModel.fromJson(doc.docs.first.data());

        return gymReportModel.isUserSignedOutForDay ? 2 : 1;
      } else {
        return 0;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String?> updateGymReportData({
    required String ownerId,
    required String formattedTime,
    required String gymId,
    required String date,
  }) async {
    try {
      var querySnapshot = await _firestore
          .collection("gym_report")
          .where('userId', isEqualTo: ownerId)
          .where("gymId", isEqualTo: gymId)
          .where("date", isEqualTo: date)
          .get();

      var userDocs = querySnapshot.docs;

      var userDocRef = userDocs.first.reference;

      await userDocRef.update(
          {'signOutTime': formattedTime, 'isUserSignedOutForDay': true});
    } on Exception catch (e) {
      log('Exception $e');
    }
    return ownerId;
  }
}
