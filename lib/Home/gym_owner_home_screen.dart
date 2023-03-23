import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:gim_app/controllers/my_collection_conroller.dart';
import 'package:gim_app/utils/gym_utils.dart';
import 'package:quickalert/quickalert.dart';

class GymOwnerHomeScreen extends StatefulWidget {
  const GymOwnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<GymOwnerHomeScreen> createState() => _GymOwnerHomeScreenState();
}

class _GymOwnerHomeScreenState extends State<GymOwnerHomeScreen> {
  final MyCollectionController controller = Get.put(MyCollectionController());

  @override
  void initState() {
    controller.fetchReportData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: GymUtils().buildBoxDecoration(),
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
                          type: QuickAlertType.confirm,
                          title: '',
                          cancelBtnText: 'No',
                          confirmBtnText: 'yes',
                          text:
                              "Are you sure you want to log out? Your session will be terminated and you will need to log in again to use the app.",
                          onConfirmBtnTap: () {
                            AuthController.instance.logout();
                            Get.to(() => const LoginScreen());
                          },
                        );
                      },
                      icon: const Icon(Icons.logout,color: Colors.white,)),
                ),
              ),
              Obx(
                () => Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: controller.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot doc = controller.documents[index];
                      return SizedBox(
                        height: 170,
                        child: Card(
                          color: Colors.transparent,
                          margin: const EdgeInsets.all(12),
                          elevation: 0.5,
                          shadowColor: Colors.blue,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              side: BorderSide(
                                color: Colors.white,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    buildText(content: 'User name: '),
                                    buildText(
                                        content:
                                            '${doc['isUserSignedOutForDay']}',
                                        isContentStyleView: true),
                                  ],
                                ),
                                Row(
                                  children: [
                                    buildText(content: 'Date: '),
                                    buildText(
                                        content:
                                        '${doc['date']}',
                                        isContentStyleView: true),
                                  ],
                                ),
                                Row(
                                  children: [
                                    buildText(content: 'Sign-in time: '),
                                    buildText(
                                        content:
                                        '${doc['signInTime']}',
                                        isContentStyleView: true),
                                  ],
                                ),
                                Row(
                                  children: [
                                    buildText(content: 'Sign-out time: '),
                                    buildText(
                                        content:
                                        '${doc['signOutTime']}',
                                        isContentStyleView: true),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildText({required String content, bool isContentStyleView = false}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        content,
        style: isContentStyleView
            ? const TextStyle(color: Colors.white)
            : const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 15),
      ),
    );
  }
}
