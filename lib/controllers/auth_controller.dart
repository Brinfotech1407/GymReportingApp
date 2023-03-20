import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/utils/gym_utils.dart';
import 'package:gim_app/models/user.dart';
import 'package:gim_app/services/preference_service.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AuthController extends GetxController {
  //AuthController.instance...
  static AuthController instance = Get.find();

  //email,pwd,name...
  late final Rx<User?> firebaseUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  final PreferenceService _preferenceService = PreferenceService();

  //will be load when app launches this func will be called and set the firebase userState
  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    //our user would be notified
    firebaseUser.bindStream(auth.userChanges());
    //listioning every changes
    // ever(firebaseUser, _initialScreen);
  }

  /*_initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      if (user.t == AppConstant.userTypeGymOwner) {
        Get.to(() => const GymDetailsScreen(ownerID: ''));
      } else {
        Get.to(() => const HomeScreen());
      }
  }
  }*/

  Future<void> loginUser(String email, password, BuildContext context) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        // No user found with the given email
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: '',
          text: 'No user found with the given email.',
        );
      }

      final userDoc = snapshot.docs.first;
      UserModel user = UserModel.fromJson(userDoc.data());

      // Check if the password matches
      if (user.password != password) {
        // Password does not match
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: '',
          text: 'Password does not match',
        );
      }

      await _preferenceService.setString(PreferenceService.userEmail, user.email);

      await _preferenceService.setString(
          PreferenceService.userName, '${user.firstName} ${user.lastName}');

      await  _preferenceService.setBool(PreferenceService.userLoggedIN, true);

      await  _preferenceService.setInt(PreferenceService.userType, user.userType);

      await  _preferenceService.setString(PreferenceService.userID, user.id);

      await _preferenceService.setBool(
          PreferenceService.ownerGymDetailsFiled, user.isGymDetailsFilled);



      GymUtils().redirectUserBasedOnType(
        userType: _preferenceService.getInt(PreferenceService.userType) ?? 0,
        ownerID: _preferenceService.getString(PreferenceService.userID) ?? '',
        ownerGymDetailsFiled: _preferenceService.getBool(
              PreferenceService.ownerGymDetailsFiled,
            ) ??
            false,
      );
    } catch (e) {
      Get.snackbar(
        "About User",
        "user message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account creation failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(e.toString()),
      );
    }
  }

  void logout() async {
    await _preferenceService.clearSharedPreference();
    await auth.signOut();
  }
}
