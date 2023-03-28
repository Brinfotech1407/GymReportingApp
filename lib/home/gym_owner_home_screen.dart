import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:gim_app/models/gym_report_model.dart';
import 'package:gim_app/services/database.dart';
import 'package:gim_app/utils/date_time_utils.dart';
import 'package:gim_app/utils/gym_utils.dart';
import 'package:gim_app/waiting/LoaderScreen.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';

class GymOwnerHomeScreen extends StatefulWidget {
  const GymOwnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<GymOwnerHomeScreen> createState() => _GymOwnerHomeScreenState();
}

class _GymOwnerHomeScreenState extends State<GymOwnerHomeScreen> {
  RxBool showFilterIcon = true.obs;
  RxBool isDateFilterView = false.obs;
  RxBool isNameFilterView = false.obs;
  RxBool showTextFiledView = false.obs;
  List<GymReportModel> arrDateFilterList = [];
  Rx<String> selectedDate = DateTimeUtils().getCurrentDate().obs;
  Rx<String>  selectedName = ''.obs;
  TextEditingController searchNameController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = [];

  @override
  void initState() {
    super.initState();
    selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: Database().fetchGymReport(
              date: selectedDate.value, searchString: selectedName.value),
          builder: (context, snapshot) {

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightGreen,
                  ));
            }
             documents = snapshot.data!.docs;
            if (selectedName.value.isNotEmpty) {
              documents = documents.where((element) {
                return element
                    .get('userName')
                    .toString()
                    .toLowerCase()
                    .contains(selectedName.value.toLowerCase());
              }).toList();
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData) {
              return const LoaderScreen(
                isFullScreen: false,
              );
            }

            final List<GymReportModel> arrGymReports = documents
                .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                    GymReportModel.fromJson(e.data()))
                .toList();
            return buildListView(
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
                        if (showTextFiledView.isTrue) ...[
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              controller: searchNameController,
                             /* onChanged: (value) {
                                setState(() {
                                  selectedName = value;
                                });
                              },*/
                              decoration: InputDecoration(
                                hintText: 'Search text',
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                border: buildOutlineInputBorder(),
                                focusedBorder: buildOutlineInputBorder(),
                                disabledBorder: buildOutlineInputBorder(),
                                enabledBorder: buildOutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(8),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search,
                                      color: Colors.white),
                                  onPressed: () {
                                      setState(() {
                                        showTextFiledView.value=false;
                                        selectedName.value = searchNameController.text;
                                        if(selectedName.isNotEmpty) {
                                          isNameFilterView.value = true;
                                          searchNameController.clear();
                                        }
                                      });
                                  },
                                ),
                              ),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              cursorColor: Colors.white,
                            ),
                          ),
                        ] else ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: filterView(
                                context: context, gymReportData: arrGymReports),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                if (snapshot.data!.docs.isNotEmpty) ...[
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
                                          content: gymReportItem.userName,
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
                ] else ...[
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text('No Data Found',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ],
            ));
          }),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(20),
    );
  }

  SafeArea buildListView({required Widget child}) {
    return SafeArea(
      child: Container(
        decoration: GymUtils().buildBoxDecoration(),
        child: child,
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

  Widget filterView(
      {required BuildContext context,
      required List<GymReportModel> gymReportData}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showTextFiledView.value =true;
                });
              },
              child: filterButtonView(
                  buttonName: isNameFilterView.isTrue ?'name: ${selectedName.value}':'name',
                  isSelectedFilterColors: isNameFilterView.isTrue,
                onCloseIconTap: () {
                  isNameFilterView.value =false;
                  selectedName.value = '';
                  searchNameController.clear();
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: filterButtonView(
                  buttonName: isDateFilterView.isTrue ?'date: ${selectedDate.value}' :'date',
              isSelectedFilterColors: isDateFilterView.isTrue,
                onCloseIconTap: () {
                  isDateFilterView.value = false;
                  selectedDate.value = DateTimeUtils().getCurrentDate();
                },
              ),
            ),
            IconButton(
                onPressed: () async {
                  setState(() {
                    showFilterIcon.value = true;
                    isDateFilterView.value = false;
                    isNameFilterView.value = false;
                    selectedName.value = '';
                    selectedDate.value = DateTimeUtils().getCurrentDate();
                  });
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100)); // Display the date picker dialog

    if (picked != null) {
      String dateString = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        selectedDate.value = dateString;
        isDateFilterView.value = true;
      });
    }
  }

  Container filterButtonView(
      {required String buttonName,
      required bool isSelectedFilterColors,
        required Function() onCloseIconTap}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelectedFilterColors ? Colors.purple.shade600 : Colors.blue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      margin: const EdgeInsets.only(bottom: 16, top: 16, right: 8, left: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SingleChildScrollView(
        child: Row(
          children: [
            Text(
             buttonName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isSelectedFilterColors != false) ...[
              IconButton(
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.only(left: 4),
                  onPressed: () async {
                      onCloseIconTap();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
