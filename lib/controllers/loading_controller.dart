import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/utils/gym_utils.dart';
import 'package:quickalert/quickalert.dart';

class LoadingController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;


  void checkLoginStatus(
      {required String emailControllerValue, required String passwordControllerValue,required BuildContext context}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    if (emailControllerValue.trim().isNotEmpty && passwordControllerValue.trim().isNotEmpty) {
      isLoggedIn.value = true;
    } else {
      // ignore: use_build_context_synchronously
      GymUtils().showAlertDialog(
          context:context,
          title: '',
          desc:'Invalid email or password.',
          confirmText:'Okay',
          showAlertdialogType: QuickAlertType.warning);
    }
  }
}
