import 'package:flutter/material.dart';
import 'package:gim_app/services/preference_service.dart';
import 'package:gim_app/utils/app_constant.dart';

import '../utils/gym_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   PreferenceService? _preferenceService;

  @override
  void initState() {
    super.initState();
    _preferenceService= PreferenceService();
    redirectToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: GymUtils().buildBoxDecoration(),
        child:  Center(
          child: Image.asset(
            'assets/images/gymIcon.png',
            width: 120,
            height: 120,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void redirectToNextScreen() {
    Future<void>.delayed(const Duration(seconds: 3), () async {
      bool isUserLoggedIn =
         _preferenceService?.getBool(PreferenceService.userLoggedIN) ?? false;
      if (isUserLoggedIn) {
        int userType = _preferenceService?.getInt(PreferenceService.userType) ??
            AppConstant.userTypeNormal;

        GymUtils().redirectUserBasedOnType(userType);
      } else {
        GymUtils().redirectToLoginScreen();
      }
    });
  }
}
