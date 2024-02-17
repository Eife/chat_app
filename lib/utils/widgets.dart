import 'package:flutter/material.dart';

// Определение функции formField
TextFormField textFormField({
  required String? Function(String?) validator,
  required TextEditingController controller,
  required String hintText,
}) {
  return TextFormField(
    validator: validator,
    controller: controller,
    decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        )),
  );
}
