import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:gim_app/models/gym_report_model.dart';
import 'package:gim_app/models/user.dart';
import 'package:gim_app/services/database.dart';
import 'package:gim_app/utils/gym_utils.dart';
import 'package:quickalert/quickalert.dart';

class GymOwnerHomeScreen extends StatefulWidget {
  const GymOwnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<GymOwnerHomeScreen> createState() => _GymOwnerHomeScreenState();
}

class _GymOwnerHomeScreenState extends State<GymOwnerHomeScreen> {
  RxBool showFilterIcon = true.obs;
  SplayTreeMap<String?, UserModel>? arrMemberList =
      SplayTreeMap<String, UserModel>();

  @override
  void initState() {
    super.initState();
    //Todo Fetch User list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: Database().fetchGymReport(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<GymReportModel> arrGymReports = snapshot.data!.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                  GymReportModel.fromJson(e.data()))
              .toList();

          return SafeArea(
            child: Container(
              decoration: GymUtils().buildBoxDecoration(),
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (showFilterIcon.isTrue) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: IconButton(
                                onPressed: () async {
                                  showFilterIcon.value = false;
                                },
                                icon: const Icon(
                                  Icons.filter_list,
                                  color: Colors.white,
                                )),
                          ),
                          Padding(
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
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                )),
                          ),
                        ] else ...[
                          Align(
                              alignment: Alignment.centerRight,
                              child: filterView(context)),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: arrGymReports.length,
                      itemBuilder: (BuildContext context, int index) {
                        GymReportModel gymReportItem = arrGymReports[index];
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
                                      buildText(content: 'name: '),
                                      buildText(
                                          content: gymReportItem.userId,
                                          isContentStyleView: true),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      buildText(content: 'Date: '),
                                      buildText(
                                          content: gymReportItem.date,
                                          isContentStyleView: true),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Column(
                                          children: [
                                            buildText(content: 'SignedIn '),
                                            buildText(
                                                content:
                                                    gymReportItem.signInTime,
                                                isContentStyleView: true),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          buildText(content: 'SignedOut '),
                                          buildText(
                                            content: gymReportItem.signOutTime,
                                            isContentStyleView: true,
                                          ),
                                        ],
                                      )
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
                ],
              ),
            ),
          );
        },
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
            : const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget filterView(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {},
              child: filterButtonView('name'),
            ),
            GestureDetector(
              onTap: () {
                GymUtils().pickDateDialog(context);
              },
              child: filterButtonView('date'),
            ),
            IconButton(
                onPressed: () async {
                  showFilterIcon.value = true;
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
          ],
        ),
      ],
    );
  }

  Container filterButtonView(String buttonName) {
    return Container(
      decoration: BoxDecoration(
        color: /* selected ?*/ Colors.blue /*: Colors.white*/,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      margin: const EdgeInsets.only(bottom: 16, top: 16, right: 8, left: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        buttonName,
        style: const TextStyle(
          color: /*selected ?*/ Colors.white,
          /*: Colors.blue,*/
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}