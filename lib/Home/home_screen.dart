import 'package:flutter/material.dart';
import 'package:gim_app/controllers/auth_controller.dart';
import 'package:gim_app/qr_scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? capture;
  MobileScannerController cameraController = MobileScannerController();
  MobileScannerArguments? arguments;

  @override
  Widget build(BuildContext context) {
    double scanArea = (MediaQuery
        .of(context)
        .size
        .width < 400 ||
        MediaQuery
            .of(context)
            .size
            .height < 400)
        ? 400.0
        : 450.0;

    return Scaffold(
        body: SafeArea(
            child: Column(
             // mainAxisAlignment: MainAxisAlignment.center,
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
                            );
                            AuthController.instance.logout();
                          },
                          icon: const Icon(Icons.logout)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 18),
                  child: Text('Gym App',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25)),
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
                            onDetect: (barcodes) {
                              capture = barcodes.barcodes.first.rawValue;
                              debugPrint('Barcode found! $capture');
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
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Text('Scan QR Code Value: ${capture ?? ''}',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blue
                      )),
                ),
              ],
            )
        )
    );
  }
}
