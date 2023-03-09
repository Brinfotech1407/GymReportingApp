import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/auth/registration.dart';
import 'package:gim_app/home_screen.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AuthController extends GetxController {
  //AuthController.instance...
  static AuthController instance = Get.find();

  //email,pwd,name...
  late final Rx<User?> firebaseUser;
  FirebaseAuth auth = FirebaseAuth.instance;

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
      Get.offAll(() => const RegistrationScreen());
    } else {
      Get.off(() => const LoginScreen());
    }
  }

  Future<void> register(String email, password, BuildContext context) async {
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
      // Check if the password matches
      if (userDoc.data()['password'] != password) {
        // Password does not match
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: '',
          text: 'Password does not match',
        );
      }

      // User found and password matches
      await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);

      Get.to(() => const HomeScreen());
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
