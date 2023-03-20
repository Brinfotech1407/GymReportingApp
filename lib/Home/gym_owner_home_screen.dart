import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:quickalert/quickalert.dart';

class GymOwnerHomeScreen extends StatefulWidget {
  const GymOwnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<GymOwnerHomeScreen> createState() => _GymOwnerHomeScreenState();
}

class _GymOwnerHomeScreenState extends State<GymOwnerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: IconButton(
                    onPressed: () async {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        title: '',
                        text: 'logout',
                        onConfirmBtnTap: () {
                          AuthController.instance.logout();
                          Get.to(() => const LoginScreen());
                        },
                      );

                    },
                    icon: const Icon(Icons.logout)),
              ),
            ),
            const Center(child: Text('Gym Owner Screen',)),
          ],
        ),
      ),
    );
  }
}
