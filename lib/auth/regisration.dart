import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:gim_app/controllers/userController.dart';
import 'package:gim_app/gym_utiles.dart';
import 'package:gim_app/models/user.dart';
import 'package:gim_app/services/database.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String dropdownValue = '1 Month';
  var items = [
    '1 Month',
    '2 Month',
    '3 Month',
    '4 Month',
    '5 Month',
    '6 Month'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetX(
          initState: (_) async {
            Get.put<UserController>(UserController());
          },
          builder: (controller) {
           return Container(
             decoration: GymUtils().buildBoxDecoration(),
             child: Column(
               children: [
                 Container(
                   alignment: Alignment.center,
                   padding:
                   const EdgeInsets.only(right: 10, top: 14, bottom: 8),
                   child: const Text(
                     'Register',
                     textAlign: TextAlign.right,
                     style: TextStyle(fontSize: 22, color: Colors.white),
                   ),
                 ),
                 GymUtils().textFormFiledView(
                     controller: _firstNameController,
                     autofillHints: [AutofillHints.name],
                     textInputType: TextInputType.name,
                     validator: (value) {},
                     hintText: 'first name'),
                 GymUtils().textFormFiledView(
                     controller: _lastNameController,
                     autofillHints: [AutofillHints.name],
                     textInputType: TextInputType.name,
                     validator: (value) {},
                     hintText: 'last name'),
                 GymUtils().textFormFiledView(
                     controller: _ageController,
                     autofillHints: [AutofillHints.birthdayDay],
                     textInputType: TextInputType.number,
                     validator: (value) {},
                     hintText: 'age'),
                 GymUtils().textFormFiledView(
                     controller: _genderController,
                     autofillHints: [AutofillHints.gender],
                     textInputType: TextInputType.text,
                     validator: (value) {},
                     hintText: 'gender'),
                 GymUtils().textFormFiledView(
                     controller: _emailController,
                     autofillHints: [AutofillHints.email],
                     textInputType: TextInputType.emailAddress,
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
                             style:
                             TextStyle(fontSize: 17, color: Colors.white),
                           ),
                         ),
                       ),
                       DropdownButton(
                         value: dropdownValue,
                         iconDisabledColor: Colors.white,
                         iconEnabledColor: Colors.white,
                         dropdownColor: Colors.blueGrey,

                         icon: const Icon(Icons.keyboard_arrow_down),
                         // Array list of items
                         items: items.map((String items) {
                           return DropdownMenuItem(
                             value: items,
                             child: Text(items,
                                 style: const TextStyle(
                                     color: Colors.white, fontSize: 14)),
                           );
                         }).toList(),
                         onChanged: (String? newValue) {
                           setState(() {
                             dropdownValue = newValue!;
                           });
                         },
                       ),
                     ],
                   ),
                 ),
                 GymUtils().buildButtonView(
                     context: context,
                     onSubmitBtnTap: () {
                       final UserModel userData = UserModel(
                         email: _emailController.text,
                         id:'1',//controller.user.id
                         mobileNo: _phoneController.text,
                         age: _ageController.text,
                         firstName: _firstNameController.text,
                         gender: _genderController.text,
                         lastName: _lastNameController.text,
                         password: _pwdController.text,
                         memberShipPlan: 2,
                       );
                       Database()
                           .createNewUser(userData.toJson(), userData.email!);
                       Get.find<UserController>().user = userData;
                     },
                     buttonName: 'Register')
               ],
             ),

             /*GetX<UserController>(
              initState: (state) async {
               *//* if (Get.find<AuthController>().auth.currentUser != null) {
                  Get.find<UserController>().user = (await Database().getUser(
                      Get.find<AuthController>().auth.currentUser!.uid))!;
                }*//*
              },
              builder: (controller) {

              },
            ),*/
           );
          },
        ),
      ),
    );
  }
}
