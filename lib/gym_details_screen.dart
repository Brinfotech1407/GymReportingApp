import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:gim_app/gym_utils.dart';

class GymDetailsScreen extends StatefulWidget {
  const GymDetailsScreen({Key? key}) : super(key: key);

  @override
  State<GymDetailsScreen> createState() => _GymDetailsScreenState();
}

class _GymDetailsScreenState extends State<GymDetailsScreen> {
  final TextEditingController _gymNameController = TextEditingController();
  final TextEditingController _gymAddressController = TextEditingController();
  final TextEditingController _gymContactNoController = TextEditingController();
  final controller = Get.put(CapacityController());

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
              padding: const EdgeInsets.only(
                  right: 10, top: 14, bottom: 8),
              child: const Text(
                'Gym Details',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 22, color: Colors.white),
              )
          ),
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
              validator: (value) {},
              hintText: 'contact number'),
                Padding(
                  padding: const EdgeInsets.only(left: 16,right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'capacity',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: controller.decrement,
                            icon: const Icon(Icons.remove, color: Colors.white),
                          ),
                          Obx(() =>
                              Text(
                                '${controller.capacity}',
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              )),
                          IconButton(
                            onPressed: controller.increment,
                            icon: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

          GymUtils().buildButtonView(
            context: context, buttonName: 'Submit', onSubmitBtnTap: () {

          },),
          ],
        ),
      ),
    ));
  }
}

class CapacityController extends GetxController {
  var capacity = 1.obs;

  void increment() => capacity.value++;

  void decrement() => capacity.value--;
}


