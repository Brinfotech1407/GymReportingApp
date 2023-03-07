
import 'package:get/get.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:gim_app/models/user.dart';

class UserController extends GetxController{
  static UserController get instance => Get.find();
  
  final _authRepo =Get.put(AuthController());

  final Rx<UserModel> _userModel = UserModel().obs;

  UserModel get user =>_userModel.value;

  set user(UserModel value) => _userModel.value =value;

  void clear(){
    _userModel.value = UserModel();
  }
}