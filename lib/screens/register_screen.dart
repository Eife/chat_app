import 'package:chat_app/bloc/bloc/register_bloc.dart';
import 'package:chat_app/utils/firestore_base.dart';
import 'package:chat_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  OptionsFirestoreBase _optionsFirestoreBase = OptionsFirestoreBase();
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController unicNickName = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController aboutMe = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    surname.dispose();
    aboutMe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Регистрация",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              20.height,
              textFormField(
                  validator: validator,
                  controller: name,
                  hintText: "Введите имя"),
              20.height,
              textFormField(
                  validator: validator,
                  controller: unicNickName,
                  hintText: "Уникальное имя пользователя(Никнейм)"),
              // 4.height,
              // TextButton(onPressed: () {}, child: child)
              20.height,
              textFormField(
                  validator: validator,
                  controller: surname,
                  hintText: "Введите фамилию"),
              20.height,
              textFormField(
                  validator: validator,
                  controller: aboutMe,
                  hintText: "Расскажите о себе"),
              10.height,
              ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 166, 102, 184))),
                  onPressed: () async {
                    if (unicNickName.text.isNotEmpty) {
                      String validatorResult =
                          await validatorFromUnicNick(unicNickName.text);
                      if (validatorResult != unicNickName.text) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Никнейм занят. Выберите другой"),
                                actions: [TextButton(onPressed: () {
                                  Navigator.of(context).pop();
                                }, child: Text('Закрыть окно'))],
                              );
                            });
                            unicNickName.text = "";
                            return;
                      }
                      
                    }

                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<RegisterBloc>(context).add(
                          RegisterUserEvent(
                              name: name.text,
                              unicNickName: unicNickName.text,
                              surname: surname.text,
                              aboutMe: aboutMe.text));
                    }
                  },
                  child: Text("Зарегистрироваться")),
            ],
          ).paddingAll(14),
        ),
      ),
    );
  }

  String? validator(String? userText) {
    if (userText == null || userText.isEmpty) {
      return "Введите данные";
    }
    return null;
  }

  Future<String> validatorFromUnicNick(String nickName) async {
    bool unicNick = await _optionsFirestoreBase.checkUnicAccount(nickName);
    if (unicNick == true) {
      return nickName;
    } else {
      return "Данный никнейм занят. Выберите другой";
    }
  }
}
