import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/auth/regisration.dart';

class AuthController extends GetxController{
  //AuthController.instance...
  static AuthController instance = Get.find();
  //email,pwd,name...
  late final Rx<User?> firebaseUser;
  FirebaseAuth auth = FirebaseAuth.instance;


 //will be load when app launches this func will be called and set the firebase userState
  @override
  void onReady(){
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    //our user would be notified
    firebaseUser.bindStream(auth.userChanges());
    //listioning every changes
    ever(firebaseUser, _initialScreen);
  }

  _initialScreen(User? user){
    if(user == null){
      print("Login page");
      Get.offAll(()=>const LoginScreen());
    }else{
      Get.off(()=>const RegistrationScreen());
    }
  }

  Future<void> register (String email,password) async {
    try{
    UserCredential _authResult = await auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      //create a user in firestore
      /*UserModel _user =UserModel(id: _authResult.user?.uid,email: _authResult.user?.email);
      await Database().createNewUser(_user, _user.id);*/
    }catch(e){
      Get.snackbar("About User", "user message",
      backgroundColor: Colors.redAccent,
      snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account creation failed",
          style: TextStyle(
color: Colors.white
          ),
        ),
        messageText:  Text(
          e.toString()
        ),
      );
    }

  }

  Future<void> login (String email,password) async {
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      Get.snackbar("About User", "user message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Login failed",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        messageText:  Text(
            e.toString()
        ),
      );
    }

  }

  void logout()async{
    await auth.signOut();
  }

  //phone authentication
loginWithPhoneNo(String phoneNumber) async {
    try{
      await auth.signInWithPhoneNumber(phoneNumber);
    }on FirebaseAuthException catch (e){
      if(e.code == 'invalid-phone-number'){
        Get.snackbar("Error", "Invalid Phone No");
      }
    }catch(_){
      Get.snackbar("Error", "Somthing went wrong");
    }
}
}