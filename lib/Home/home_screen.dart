import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:gim_app/models/gym_report_model.dart';
import 'package:gim_app/qr_scanner_overlay.dart';
import 'package:gim_app/services/database.dart';
import 'package:gim_app/waiting/LoaderScreen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:uuid/uuid.dart';
import "package:intl/intl.dart";

class HomeScreen extends StatefulWidget {
  final String currentUserID;

  const HomeScreen({super.key, required this.currentUserID});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? scannerId;
  MobileScannerController cameraController = MobileScannerController();
  MobileScannerArguments? arguments;

  bool isStarted = true;
  RxBool isLoaded = false.obs;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      if (isStarted) {
        cameraController.stop();
      } else {
        cameraController.start();
      }
      isStarted = !isStarted;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double scanArea = buildScanArea(context);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
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
                    onDetect: (barcodes)  async {
                      scannerId = barcodes.barcodes.first.rawValue;
                      if (scannerId != null && scannerId!.isNotEmpty) {
                        cameraController.stop();
                        isLoaded.toggle();
                        showWaitingScreen();

                     GymReportModel? gymData = await Database().getGymReportData(widget.currentUserID);

                        if (gymData != null && gymData.userId.isNotEmpty  &&
                            gymData.date == formattedDate) {
                          // ignore: use_build_context_synchronously
                          await Database().updateGymReportData(
                              widget.currentUserID, formattedTime, context);
                        } else {
                          // ignore: use_build_context_synchronously
                          await createGymReport(
                              barcodes, formattedDate, formattedTime, context);
                        }

                        isLoaded.value = false;
                      } else {
                        cameraController.start();
                      }
                      debugPrint('Barcode found! $scannerId');
                    }),
                const QRScannerOverlay(overlayColour: Colors.white),
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

  void showWaitingScreen() {
    if (isLoaded.value == true) {
      Get.to(const LoaderScreen(
        isFullScreen: true,
      ));
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
