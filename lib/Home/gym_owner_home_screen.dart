import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:gim_app/controllers/my_collection_conroller.dart';
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
                    icon: const Icon(Icons.logout)),
              ),
            ),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: controller.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot doc = controller.documents[index];
                    return SizedBox(
                      height: 140,
                      child: Card(
                        margin: const EdgeInsets.all(12),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            side: BorderSide(
                              color: Colors.grey,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Customer Name: ${doc['id']}',
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              Text('Date: ${doc['date']}'),
                               Text('Sign-in time: ${doc['signInTime']}'),
                              Text('Sign-out time: ${doc['signOutTime']}'),
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
    );
  }
}
