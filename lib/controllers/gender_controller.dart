import 'package:get/get.dart';

class GenderController extends GetxController {
  var gender = 'male'.obs;

  void setGender(String value) {
    gender.value = value;
  }
}
