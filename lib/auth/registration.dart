import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/controllers/gender_controller.dart';
import 'package:gim_app/gym_utils.dart';
import 'package:gim_app/models/user.dart';
import 'package:gim_app/services/database.dart';
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
  RxInt dropdownValue = 1.obs;

  var itemList = [1, 2, 3, 4, 5, 6].obs;

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
                  hintText: 'first name'),
              GymUtils().textFormFiledView(
                  controller: _lastNameController,
                  autofillHints: [AutofillHints.nameSuffix],
                  textInputType: TextInputType.name,
                  keyboardType: TextInputType.text,
                  validator: (value) {},
                  hintText: 'last name'),
              GymUtils().textFormFiledView(
                  controller: _ageController,
                  autofillHints: [AutofillHints.birthday],
                  textInputType: TextInputType.number,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  isMaxLength: true,
                  validator: (value) {},
                  hintText: 'age'),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, right: 8),
                    child: Text('Gender',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  )),
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
                      return 'Enter a valid phone number';
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
                  validator: (value) {},
                  hintText: 'Password'),
              Container(
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
                            print(dropdownValue.value);
                          },
                          value: dropdownValue.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GymUtils().buildButtonView(
                  context: context,
                  onSubmitBtnTap: () async {
                    if (_emailController.text.isNotEmpty &&
                        _pwdController.text.isNotEmpty &&
                        _lastNameController.text.isNotEmpty &&
                        genderController.gender.value.isNotEmpty &&
                        _firstNameController.text.isNotEmpty &&
                        _ageController.text.isNotEmpty &&
                        _phoneController.text.isNotEmpty) {
                      final UserModel userData = UserModel(
                        email: _emailController.text,
                        id: const Uuid().v4(),
                        mobileNo: _phoneController.text,
                        age: _ageController.text,
                        firstName: _firstNameController.text,
                        gender: genderController.gender.value,
                        lastName: _lastNameController.text,
                        password: _pwdController.text,
                        memberShipPlan: dropdownValue.value,
                      );
                      await Database()
                          .createNewUser(userData.toJson(), userData.email!);

                      _emailController.clear();
                      _pwdController.clear();
                      _lastNameController.clear();
                      _firstNameController.clear();
                      _ageController.clear();
                      _phoneController.clear();
                      Get.to(const LoginScreen());
                    }
                  },
                  buttonName: 'Register'),
            ],
          ),
        ),
      ),
    );
  }
}
