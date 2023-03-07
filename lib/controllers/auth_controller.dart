
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/auth/registration.dart';
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
    ever(firebaseUser, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print("Login page");
      Get.offAll(() => const RegistrationScreen());
    } else {
      Get.off(() => const LoginScreen());
    }
  }

  Future<void> register(String email, password,BuildContext context) async {
    try {
      await _preferenceService.init();
      var  storeUserEmail = _preferenceService.getUserEmail('USEREMAIL')?? '';
      print('storeUserEmail $storeUserEmail');
      if(email == storeUserEmail) {
        await auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password);
      }else{
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: '',
          text:
          'Enterd data is not correct.',
        );
      }

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

  Future<void> login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar(
        "About User",
        "user message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Login failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(e.toString()),
      );
    }
  }

  void logout() async {
    await auth.signOut();
  }

  //phone authentication
  loginWithPhoneNo(String phoneNumber) async {
    try {
      await auth.signInWithPhoneNumber(phoneNumber);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-phone-number') {
        Get.snackbar("Error", "Invalid Phone No");
      }
    } catch (_) {
      Get.snackbar("Error", "Somthing went wrong");
    }
  }
}
