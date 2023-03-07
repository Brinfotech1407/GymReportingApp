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
    required TextInputType keyboardType,
    required Function(String? value) validator,
    bool obscureText = false,
    bool readOnly = false,
    bool isMaxLength = false,
    int maxLength = 3,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        autofillHints: autofillHints,
        cursorColor: Colors.black,
        obscureText: obscureText,
        readOnly: readOnly,
        maxLength: isMaxLength ? maxLength : null,
        decoration: InputDecoration(
            counterText: "",
            hintText: hintText,
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
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
            disabledBorder: const OutlineInputBorder()),
        keyboardType: keyboardType,
        validator: (String? value) {
          validator(value);
        },
      ),
    );
  }
}
