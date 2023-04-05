import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;


  void checkLoginStatus(
      {required String emailControllerValue, required String passwordControllerValue}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    if (emailControllerValue.trim().isNotEmpty && passwordControllerValue.trim().isNotEmpty) {
      isLoggedIn.value = true;
    } else {
      Get.snackbar(
        'Error',
        'Invalid email or password.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
// ...
}
