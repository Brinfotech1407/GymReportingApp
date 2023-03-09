import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {

  final String value;
  final Function() screenClosed;
  const ProfileScreen({
    Key? key,
    required this.value,
    required this.screenClosed,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body:  Center(
          child: Text('This is the Profile screen. ${widget.value}'),
        ),
    );
  }
}