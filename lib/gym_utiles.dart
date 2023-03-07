import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GymUtils {
  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.blue.shade200, Colors.lightBlue, Colors.purple],
      ),
    );
  }

  Widget buildButtonView(
      {required BuildContext context,
      required Function() onSubmitBtnTap,
      required String buttonName}) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      height: 50,
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(27)))),
        onPressed: () {
          onSubmitBtnTap();
        },
        child: Text(
          buttonName,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }

  Widget textFormFiledView({
    required TextEditingController controller,
    required Iterable<String> autofillHints,
    required String hintText,
    required TextInputType textInputType,
    required Function(String? value) validator,

  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Form(
        child: TextFormField(
          controller: controller,
          autofillHints: autofillHints,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              hintText:hintText,
              hintStyle: const TextStyle(fontSize: 14),
              focusColor: Colors.black,
              fillColor: Colors.grey.shade100,
              filled: true,
              contentPadding: const EdgeInsets.only(left: 10),
              border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              disabledBorder: const OutlineInputBorder()),
          keyboardType: TextInputType.emailAddress,
          validator: (String? value) {
            validator(value);
          },
        ),
      ),
    );
  }
}
