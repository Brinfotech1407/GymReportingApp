import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/auth/registration.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:gim_app/utils/gym_utils.dart';
import 'package:gim_app/waiting/LoaderScreen.dart';

class LoginScreen extends StatefulWidget {
  final String? ownerID;

  const LoginScreen({super.key, this.ownerID});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  RxBool isLoaded = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: GymUtils().buildBoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/gymIcon.png',
                width: 60,
                height: 60,
                color: Colors.white,
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                    child: const Text(
                      'WELCOME TO',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                      right: 10,
                      top: 8,
                      bottom: 20,
                    ),
                    child: const Text(
                      'FITNESS APP',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              GymUtils().textFormFiledView(
                  controller: _emailController,
                  autofillHints: [AutofillHints.namePrefix],
                  textInputType: TextInputType.emailAddress,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
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
                  hintText: 'Enter your email...'),
              //emailFormFiledView(),
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
                      return 'Enter your password...';
                    } else {
                      return null;
                    }
                  },
                  hintText: 'Enter your password...'),
              //passwordFormFiledView(),
              GymUtils().buildButtonView(
                  context: context,
                  onSubmitBtnTap: () async {
                    isLoaded.toggle();
                    if (_emailController.text.isNotEmpty &&
                        _pwdController.text.isNotEmpty) {
                      if (isLoaded.value == true) {
                        const LoaderScreen(
                          isFullScreen: false,
                        );
                      }
                      isLoaded.value = false;
                      await AuthController.instance.loginUser(
                          _emailController.text, _pwdController.text, context);
                    }
                  },
                  buttonName: 'Login'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account yet? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const RegistrationScreen());
                      },
                      child: const Text(
                        "Register",
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
}
