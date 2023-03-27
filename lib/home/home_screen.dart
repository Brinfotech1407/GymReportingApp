import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gim_app/auth/login_screen.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:gim_app/models/gym_details.dart';
import 'package:gim_app/models/gym_report_model.dart';
import 'package:gim_app/qr_scanner_overlay.dart';
import 'package:gim_app/services/database.dart';
import 'package:gim_app/utils/date_time_utils.dart';
import 'package:gim_app/utils/gym_utils.dart';
import 'package:gim_app/waiting/LoaderScreen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:uuid/uuid.dart';

import '../thank_you.dart';

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
                    cameraController.stop();
                    processQRCode(barcode.barcodes.first.rawValue!, context);
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

  Future<void> processQRCode(String scanID, BuildContext context) async {
    scannerId.value = scanID;
    isLoaded.value = true;

    if (scannerId.isNotEmpty) {
      bool isPresent = await checkIfGymAlreadyPresent(context);
      if (isPresent) {
        String currentDate = DateTimeUtils().getCurrentDate();
        String time = DateTimeUtils().getCurrentTime();

        int userStatus = await Database().checkUserAlreadySignedIn(
            widget.currentUserID, scanID, currentDate);

        if (userStatus == 1) {
          //update
          await Database().updateGymReportData(
            formattedTime: time,
            date: currentDate,
            gymId: scanID,
            ownerId: widget.currentUserID,
          );
          Get.to(const ThankYouScreen());
        } else if (userStatus == 0) {
          //insert
          await createGymReport(
            gymID: scanID,
            context: context,
            formattedDate: currentDate,
            formattedTime: time,
          );
          Get.to(const ThankYouScreen());
        } else if (userStatus == 2) {
          GymUtils().showAlertDialog(
            context: context,
            title: '',
            desc: 'Sorry, it appears that you have already signed in and out.thanks',
            confirmText: 'Okay',
            showAlertdialogType: QuickAlertType.warning
          );
        }
      } else {
        GymUtils().showAlertDialog(
            context: context,
            title: '',
            desc:  "We're sorry, but the gym you are looking for could not be found.",
            confirmText: 'Okay',
            showAlertdialogType: QuickAlertType.warning
        );
      }
      isLoaded.value = false;
      Future.delayed(const Duration(seconds: 3));
      cameraController.start();
    } else {
      GymUtils().showAlertDialog(
          context: context,
          title: '',
          desc: "gym you are looking for could not be found.invalid QR code",
          confirmText: 'Okay',
          showAlertdialogType: QuickAlertType.warning
      );
    }
  }

  Future<bool> checkIfGymAlreadyPresent(BuildContext context) async {
    GymDetailsModel? gymDetails =
        await Database().isGymPresent(scannerId.value);
    return gymDetails != null;
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

  Future<void> createGymReport({
    required String gymID,
    required String formattedDate,
    required String formattedTime,
    required BuildContext context,
  }) async {
    GymReportModel gymReport = GymReportModel(
      id: gymUserID(),
      gymId: gymID,
      userId: widget.currentUserID,
      date: formattedDate,
      signInTime: formattedTime,
      signOutTime: '0',
      isUserSignedOutForDay: false,
    );

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
