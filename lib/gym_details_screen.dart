import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:gim_app/utils/gym_utils.dart';
import 'package:gim_app/models/gym_details.dart';
import 'package:gim_app/services/database.dart';
import 'package:uuid/uuid.dart';

import 'Home/gym_owner_home_screen.dart';

class GymDetailsScreen extends StatefulWidget {
  final String ownerID;

  const GymDetailsScreen({super.key, required this.ownerID});

  @override
  State<GymDetailsScreen> createState() => _GymDetailsScreenState();
}

class _GymDetailsScreenState extends State<GymDetailsScreen> {
  final TextEditingController _gymNameController = TextEditingController();
  final TextEditingController _gymAddressController = TextEditingController();
  final TextEditingController _gymContactNoController = TextEditingController();
  final capacityController = Get.put(CapacityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: GymUtils().buildBoxDecoration(),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 10, top: 14, bottom: 8),
                child: const Text(
                  'Gym Details',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 22, color: Colors.white),
                )),
            GymUtils().textFormFiledView(
                controller: _gymNameController,
                autofillHints: [AutofillHints.namePrefix],
                textInputType: TextInputType.name,
                keyboardType: TextInputType.text,
                validator: (value) {},
                hintText: 'name'),
            GymUtils().textFormFiledView(
                controller: _gymAddressController,
                autofillHints: [AutofillHints.fullStreetAddress],
                textInputType: TextInputType.streetAddress,
                keyboardType: TextInputType.streetAddress,
                validator: (value) {},
                hintText: 'address'),
            GymUtils().textFormFiledView(
                controller: _gymContactNoController,
                autofillHints: [AutofillHints.telephoneNumber],
                textInputType: TextInputType.phone,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                isMaxLength: true,
                validator: (value) {
                  Pattern pattern =
                      r'^(?:\+?1[-.●]?)?\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$';
                  RegExp regex = RegExp(pattern.toString());
                  if (!regex.hasMatch(value!)) {
                    return 'Enter a valid phone number';
                  } else {
                    return null;
                  }
                },
                hintText: 'contact number'),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'capacity',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: capacityController.decrement,
                        icon: const Icon(Icons.remove, color: Colors.white),
                      ),
                      Obx(() => Text(
                            '${capacityController.capacity}',
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          )),
                      IconButton(
                        onPressed: capacityController.increment,
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GymUtils().buildButtonView(
              context: context,
              buttonName: 'Submit',
              onSubmitBtnTap: () async {
                if (_gymContactNoController.text.isNotEmpty &&
                    _gymAddressController.text.isNotEmpty &&
                    _gymNameController.text.isNotEmpty) {
                  final GymDetailsModel gymDetails = GymDetailsModel(
                    id: gymUserID(),
                    name: _gymNameController.text,
                    address: _gymAddressController.text,
                    capacity: capacityController.capacity.value,
                    contactNo: _gymContactNoController.text,
                    ownerId: widget.ownerID,
                  );
                  await Database()
                      .createGymDetails(gymDetails.toJson(), gymUserID(), context);

                  _gymNameController.clear();
                  _gymAddressController.clear();
                  _gymContactNoController.clear();
                  Get.to(() => const GymOwnerHomeScreen());
                }
              },
            ),
          ],
        ),
      ),
    ));
  }

  String gymUserID() {
    return const Uuid().v4();
  }
}

class CapacityController extends GetxController {
  var capacity = 10.obs;

  void increment() => capacity.value += 10;

  void decrement() => capacity.value -= 10;
}
