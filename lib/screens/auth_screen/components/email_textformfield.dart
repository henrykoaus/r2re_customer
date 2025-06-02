import 'package:flutter/material.dart';

class EmailTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String hintText;

  const EmailTextFormField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: Colors.grey,
      obscureText: obscureText,
      decoration: textInputDecor(hintText),
      autocorrect: false,
      textInputAction: TextInputAction.go,
    );
  }

  InputDecoration textInputDecor(String hint) {
    return InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100]);
  }
}
