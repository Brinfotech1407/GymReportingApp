import 'package:get/get.dart';

class UserTypeController extends GetxController {
  var userType = 0.obs;

  void setUserType(int value) {
    userType.value = value;
  }
}
