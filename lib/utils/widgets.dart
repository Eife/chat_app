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

Container showUser(String name, String surname) {
  return Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: const Color.fromARGB(255, 132, 126, 73)),
    child: Center(
      child: Text(
        "${name.substring(0, 1)}${surname.substring(0, 1)}",
        style: TextStyle(fontSize: 22),
      ),
    ),
  );
}

SizedBox settingsBox(String info, String subInfo, IconData icon) {
  return SizedBox(
    height: 80,
    child: ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        info, style: TextStyle(color: Colors.white), 
      ),
      subtitle: Text(
        subInfo, style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
