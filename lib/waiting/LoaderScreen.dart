import 'package:flutter/material.dart';
import 'package:gim_app/waiting/splash_screen.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key? key, required this.isFullScreen}) : super(key: key);

  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? const SplashScreen()
        : const CircularProgressIndicator(color: Colors.green);
  }
}
