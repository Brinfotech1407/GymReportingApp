import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/controllers/gender_controller.dart';
import 'package:gim_app/controllers/user_type_controller.dart';
import 'package:gim_app/utils/gym_utils.dart';
import 'package:gim_app/models/user.dart';
import 'package:gim_app/services/database.dart';
import 'package:gim_app/services/notification_service.dart';
import 'package:gim_app/waiting/LoaderScreen.dart';
import 'package:uuid/uuid.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GenderController genderController = Get.put(GenderController());
  final UserTypeController userTypeController = Get.put(UserTypeController());
  RxInt dropdownValue = 1.obs;
  String deviceToken = '';
  RxBool isLoaded = false.obs;

  var itemList = [1, 2, 3, 4, 5, 6].obs;

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      deviceToken = value;
      print('Device Token value => $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: GymUtils().buildBoxDecoration(),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 10, top: 14, bottom: 8),
                child: const Text(
                  'Register',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
              GymUtils().textFormFiledView(
                  controller: _firstNameController,
                  autofillHints: [AutofillHints.namePrefix],
                  textInputType: TextInputType.name,
                  keyboardType: TextInputType.text,
                  validator: (value) {},
                  hintText: 'First Name'),
              GymUtils().textFormFiledView(
                  controller: _lastNameController,
                  autofillHints: [AutofillHints.nameSuffix],
                  textInputType: TextInputType.name,
                  keyboardType: TextInputType.text,
                  validator: (value) {},
                  hintText: 'Last Name'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Obx(() {
                      return RadioListTile(
                        value: 'male',
                        activeColor: Colors.white,
                        title: const Text('Male',
                            style: TextStyle(color: Colors.white)),
                        groupValue: genderController.gender.value,
                        onChanged: (value) {
                          genderController.setGender(value!);
                        },
                      );
                    }),
                  ),
                  Flexible(
                    child: Obx(() {
                      return RadioListTile(
                        value: 'Female',
                        activeColor: Colors.white,
                        title: const Text('Female',
                            style: TextStyle(color: Colors.white)),
                        groupValue: genderController.gender.value,
                        onChanged: (value) {
                          genderController.setGender(value!);
                        },
                      );
                    }),
                  ),
                ],
              ),
              GymUtils().textFormFiledView(
                  controller: _ageController,
                  autofillHints: [AutofillHints.birthday],
                  textInputType: TextInputType.number,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  isMaxLength: true,
                  validator: (value) {},
                  hintText: 'age'),
              GymUtils().textFormFiledView(
                  controller: _emailController,
                  autofillHints: [AutofillHints.email],
                  textInputType: TextInputType.emailAddress,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    const pattern =
                        r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                    RegExp regex = RegExp(pattern.toString());
                    if (!regex.hasMatch(value!)) {
                      return 'Enter a valid email';
                    } else {
                      return null;
                    }
                  },
                  hintText: 'email'),
              GymUtils().textFormFiledView(
                  controller: _phoneController,
                  autofillHints: [AutofillHints.telephoneNumber],
                  textInputType: TextInputType.number,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  isMaxLength: true,
                  validator: (value) {
                    Pattern pattern =
                        r'^(?:\+?1[-.●]?)?\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$';
                    RegExp regex = RegExp(pattern.toString());
                    if (!regex.hasMatch(value!)) {
                      return 'Enter a valid phone number';
                    } else {
                      return null;
                    }
                  },
                  hintText: 'mobile number'),
              GymUtils().textFormFiledView(
                  controller: _pwdController,
                  autofillHints: [AutofillHints.password],
                  textInputType: TextInputType.visiblePassword,
                  keyboardType: TextInputType.visiblePassword,
                  maxLength: 6,
                  isMaxLength: true,
                  obscureText: true,
                  validator: (value) {
                    Pattern pattern =
                        r'^(?:\+?1[-.●]?)?\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$';
                    RegExp regex = RegExp(pattern.toString());
                    if (!regex.hasMatch(value!)) {
                      return 'Enter a valid Password';
                    } else {
                      return null;
                    }
                  },
                  hintText: 'Password'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Obx(() {
                      return RadioListTile(
                        value: 0,
                        activeColor: Colors.white,
                        title: const Text('User',
                            style: TextStyle(color: Colors.white)),
                        groupValue: userTypeController.userType.value,
                        onChanged: (value) {
                          userTypeController.setUserType(value!);
                        },
                      );
                    }),
                  ),
                  Flexible(
                    child: Obx(() {
                      return RadioListTile(
                        value: 1,
                        activeColor: Colors.white,
                        title: const Text('GymOwner',
                            style: TextStyle(color: Colors.white)),
                        groupValue: userTypeController.userType.value,
                        onChanged: (int? value) {
                          userTypeController.setUserType(value!);
                        },
                      );
                    }),
                  ),
                ],
              ),

              Obx(
                    () => userTypeController.userType.value == 0
                    ?  Container(
                      margin: const EdgeInsets.only(
                          left: 18, top: 14, bottom: 8, right: 18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Membership Plan',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 17, color: Colors.white),
                              ),
                            ),
                          ),
                          Obx(
                                () => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: DropdownButton<int>(
                                iconDisabledColor: Colors.white,
                                iconEnabledColor: Colors.white,
                                dropdownColor: Colors.blueGrey,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: itemList.map((int items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text('$items Months',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  dropdownValue.value = newValue!;
                                },
                                value: dropdownValue.value,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : Container(),
              ),


              GymUtils().buildButtonView(
                  context: context,
                  onSubmitBtnTap: () async {
                    isLoaded.toggle();
                    if (_emailController.text.isNotEmpty &&
                        _pwdController.text.isNotEmpty &&
                        _lastNameController.text.isNotEmpty &&
                        genderController.gender.value.isNotEmpty &&
                        _firstNameController.text.isNotEmpty &&
                        _ageController.text.isNotEmpty &&
                        _phoneController.text.isNotEmpty) {
                      if (isLoaded.value == true) {
                        Get.to(const LoaderScreen(
                          isFullScreen: false,
                        ));
                      }
                      final UserModel userData = UserModel(
                        email: _emailController.text,
                        id: userID(),
                        mobileNo: _phoneController.text,
                        age: _ageController.text,
                        firstName: _firstNameController.text,
                        gender: genderController.gender.value,
                        lastName: _lastNameController.text,
                        password: _pwdController.text,
                        memberShipPlan: dropdownValue.value,
                        deviceToken: deviceToken,
                        userType: userTypeController.userType.value,
                        isGymDetailsFilled: false,
                      );
                      await Database().createNewUser(userData, context);

                      _emailController.clear();
                      _pwdController.clear();
                      _lastNameController.clear();
                      _firstNameController.clear();
                      _ageController.clear();
                      _phoneController.clear();

                      isLoaded.value = false;
                      Get.to(LoginScreen(ownerID: userID()));
                    }
                  },
                  buttonName: 'Register'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => LoginScreen(
                              ownerID: userID(),
                            ));
                      },
                      child: const Text(
                        "log-in",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String userID() {
    return const Uuid().v4();
  }
}
