import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:gim_app/profile_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  BarcodeCapture? capture;
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;


  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight = screenHeight * 0.5; // 50% of screen height
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return  Wrap(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.lightBlue, Colors.blue.shade200],
                      ),
                      borderRadius: const BorderRadiusDirectional.only(bottomEnd: Radius.circular(20),bottomStart: Radius.circular(20))
                  ),
                  child: const Center(
                    child: Text('Scan QR Code here',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: ValueListenableBuilder(
                        valueListenable: cameraController.torchState,
                        builder: (context, state, child) {
                          switch (state) {
                            case TorchState.off:
                              return const Icon(Icons.flash_off, color: Colors.grey);
                            case TorchState.on:
                              return const Icon(Icons.flash_on, color: Colors.yellow);
                          }
                        },
                      ),
                      iconSize: 32.0,
                      onPressed: () => cameraController.toggleTorch(),
                    ),
                    IconButton(
                      icon: ValueListenableBuilder(
                        valueListenable: cameraController.cameraFacingState,
                        builder: (context, state, child) {
                          switch (state as CameraFacing) {
                            case CameraFacing.front:
                              return const Icon(Icons.camera_front);
                            case CameraFacing.back:
                              return const Icon(Icons.camera_rear);
                          }
                        },
                      ),
                      iconSize: 32.0,
                      onPressed: () => cameraController.switchCamera(),
                    ),
                  ],),
                SizedBox(
                  height: containerHeight,
                  child: MobileScanner(
                    fit: BoxFit.cover,
                    controller: cameraController,
                    onDetect: (BarcodeCapture capture) {
                      setState(() {
                        if (!_screenOpened) {
                          this.capture = capture;
                          _screenOpened = true;
                          Future.delayed(Duration(seconds: 2));
                          Get.to(ProfileScreen(screenClosed: _screenWasClosed,
                            value: capture.barcodes.first.rawValue ??
                                'Scan something!',));
                        }
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),

    );
  }
  void _screenWasClosed() {
    _screenOpened = false;
  }
}
