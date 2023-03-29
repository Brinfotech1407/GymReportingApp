import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gim_app/Home/gym_owner_home_screen.dart';
import 'package:gim_app/Home/home_screen.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/gym_details_screen.dart';
import 'package:gim_app/models/gym_details.dart';
import 'package:gim_app/services/database.dart';
import 'package:gim_app/services/preference_service.dart';
import 'package:gim_app/utils/app_constant.dart';
import 'package:quickalert/quickalert.dart';

class GymUtils {
  final PreferenceService _preferenceService = PreferenceService();

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.blue.shade200, Colors.lightBlue, Colors.purple],
      ),
    );
  }

  Widget buildButtonView(
      {required BuildContext context,
      required Function() onSubmitBtnTap,
      required String buttonName}) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: 130,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            )),
        onPressed: () {
          onSubmitBtnTap();
        },
        child: Text(
          buttonName,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }

  Widget textFormFiledView({
    required TextEditingController controller,
    required Iterable<String> autofillHints,
    required String hintText,
    required TextInputType textInputType,
    required TextInputType keyboardType,
    required Function(String? value) validator,
    bool obscureText = false,
    bool readOnly = false,
    bool isMaxLength = false,
    int maxLength = 3,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        autofillHints: autofillHints,
        cursorColor: Colors.black,
        obscureText: obscureText,
        readOnly: readOnly,
        maxLength: isMaxLength ? maxLength : null,
        decoration: InputDecoration(
            counterText: "",
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14),
            focusColor: Colors.black,
            fillColor: Colors.grey.shade100,
            filled: true,
            contentPadding: const EdgeInsets.only(left: 10),
            border: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0x00000000),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBorder: const OutlineInputBorder()),
        keyboardType: keyboardType,
        validator: (String? value) {
          return validator(value);
        },
      ),
    );
  }

  void redirectUserBasedOnType(
      {required int userType,
      required String ownerID,
      required bool ownerGymDetailsFiled}) {
    if (userType == AppConstant.userTypeNormal) {
      Get.to(() => HomeScreen(
            currentUserID: ownerID,
          ));
    } else {
      showOwnerScreens(
          ownerGymDetailsFiled: ownerGymDetailsFiled, ownerID: ownerID);
    }
  }

  Future<void> showOwnerScreens(
      {required bool ownerGymDetailsFiled, required String ownerID}) async {
    if (ownerGymDetailsFiled) {
      GymDetailsModel? gymDetails = await Database().getGymDetails(ownerID);
      _preferenceService.setString(PreferenceService.gymID, gymDetails?.id);
      Get.to(() => const GymOwnerHomeScreen());
    } else {
      Get.to(() => GymDetailsScreen(
            ownerID: ownerID,
          ));
    }
  }

  void redirectToLoginScreen() {
    Get.to(() => const LoginScreen());
  }

  void showAlertDialog({
    required BuildContext context,
    required String title,
    required String desc,
    required String confirmText,
    required QuickAlertType showAlertdialogType,
  }) {
    if (showAlertdialogType == QuickAlertType.warning) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: title,
          confirmBtnText: confirmText,
          text: desc);
    } else if (showAlertdialogType == QuickAlertType.info) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          title: title,
          confirmBtnText: confirmText,
          text: desc);
    } else if (showAlertdialogType == QuickAlertType.loading) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: title,
          confirmBtnText: confirmText,
          text: desc);
    } else if (showAlertdialogType == QuickAlertType.error) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: title,
          confirmBtnText: confirmText,
          text: desc);
    }
  }

  pickDateDialog(BuildContext context) {
    Rx<DateTime> selectedDate = DateTime.now().obs;
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(2000),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      //for rebuilding the ui
      selectedDate.value = pickedDate;
    });
  }


  toastMessageView({required String toastMessage}){
    Fluttertoast.showToast(
      msg: toastMessage,
      backgroundColor: Colors.grey[600],
    );

  }
}
