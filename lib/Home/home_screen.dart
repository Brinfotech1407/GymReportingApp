import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:gim_app/models/gym_details.dart';
import 'package:gim_app/models/gym_report_model.dart';
import 'package:gim_app/qr_scanner_overlay.dart';
import 'package:gim_app/services/database.dart';
import 'package:gim_app/waiting/LoaderScreen.dart';

// ignore: depend_on_referenced_packages
import "package:intl/intl.dart";
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserID;

  const HomeScreen({super.key, required this.currentUserID});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  RxString scannerId = ''.obs;
  MobileScannerController cameraController = MobileScannerController();
  MobileScannerArguments? arguments;

  RxBool isStarted = true.obs;
  RxBool isLoaded = false.obs;
  DateTime now = DateTime.now();

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (isStarted.isTrue) {
      cameraController.stop();
    } else {
      cameraController.start();
    }
    isStarted.value = !isStarted.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double scanArea = buildScanArea(context);
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
                  showAlertDialog(context);
                },
                icon: const Icon(Icons.logout)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 18),
          child: Text('Gym App',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: scanArea,
            width: scanArea,
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(
                  controller: cameraController,
                  fit: BoxFit.contain,
                  onDetect: (barcode) async {
                    RxString formattedDate =
                        DateFormat('yyyy-MM-dd').format(now).obs;
                    RxString formattedTime =
                        DateFormat('HH:mm:ss').format(now).obs;

                    scannerId.value = barcode.barcodes.first.rawValue!;

                    print(scannerId.value);

                    if (scannerId.isNotEmpty) {
                      cameraController.stop();
                      isLoaded.value = true;

                      GymDetailsModel? gymDetails =
                          await Database().isGymPresent(scannerId.value);
                      if (gymDetails != null) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: '',
                          text: "Gym Found",
                        );
                      } else {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: '',
                          text:
                              "Sorry, Gym not found please try another QRCode",
                        );
                      }
                      isLoaded.value = false;
                      cameraController.start();
                    }

                    /*GymReportModel? gymData;

                      gymData = await Database()
                          .getSingleGymReportData(widget.currentUserID);

                      if (gymData != null &&
                          gymData.gymId == scannerId.value &&
                          gymData.isUserSignedOutForDay == true) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: '',
                          text:
                              "Sorry, you have already signed in and out of the gym today. You cannot enter the gym again.",
                        );
                      } else if (gymData != null &&
                          widget.currentUserID == gymData.userId &&
                          gymData.signInTime != formattedTime.value &&
                          gymData.date == formattedDate.value &&
                          gymData.isUserSignedOutForDay == false &&
                          gymData.gymId == scannerId.value) {
                        // ignore: use_build_context_synchronously
                        await Database().updateGymReportData(
                            widget.currentUserID, formattedTime.value, context);

                        Get.to(const ThankYouScreen());
                      } else {
                        // ignore: use_build_context_synchronously
                        await createGymReport(barcode, formattedDate.value,
                            formattedTime.value, context);

                        Get.to(const ThankYouScreen());
                      }
                      isLoaded.value = false;
                    }
                    cameraController.start();*/
                  },
                ),
                QRScannerOverlay(
                    overlayColour: Colors.white, isLoaded: isLoaded.value),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 18),
          child: Text('Scan QR Code here',
              style: TextStyle(
                fontSize: 20,
              )),
        ),
      ],
    )));
  }

  void showAlertDialog(BuildContext context) {
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
        });
  }

  Widget showWaitingScreen() {
    if (isLoaded.value == true) {
      return const Center(
        child: LoaderScreen(
          isFullScreen: false,
        ),
      );
    } else {
      return Container();
    }
  }

  Future<void> createGymReport(BarcodeCapture barcodes, String formattedDate,
      String formattedTime, BuildContext context) async {
    GymReportModel gymReport = GymReportModel(
        id: gymUserID(),
        gymId: barcodes.barcodes.first.rawValue!,
        userId: widget.currentUserID,
        date: formattedDate,
        signInTime: formattedTime,
        signOutTime: '0',
        isUserSignedOutForDay: false);

    await Database().createGymReport(gymReport, context);
  }

  String gymUserID() {
    return const Uuid().v4();
  }

  double buildScanArea(BuildContext context) {
    double scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 400.0
        : 450.0;
    return scanArea;
  }
}
