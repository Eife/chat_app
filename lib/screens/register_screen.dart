import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController aboutMe = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: name,
                decoration: InputDecoration(hintText: "Введите ваше имя"),
              ),
              TextFormField(
                controller: surname,
                decoration: InputDecoration(hintText: "Введите фамилию"),
              ),
              TextFormField(
                controller: aboutMe,
                decoration: InputDecoration(hintText: "О себе"),
              ),
              ElevatedButton(onPressed: () {}, child: Text("Зарегистрироваться")),
            ],
          ),
        ),
      ),
    );
  }
}