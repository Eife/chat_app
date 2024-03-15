import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/screens/start_screen.dart';
import 'package:chat_app/utils/images.dart';
import 'package:chat_app/utils/local_database.dart';
import 'package:chat_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  LocalStorageService _localStorageService = LocalStorageService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        
        toolbarHeight: 40,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(160, 36, 32, 37),
        title: Text(
          "Настройки",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(background_settings), fit: BoxFit.cover)),
        child: Column(
          children: [
            Container(
              height: 100,
              child: Row(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "Name",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "surname",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
              height: 1,
            ),
            settingsBox("Аккаунт", "Сохранение аккаунта", Icons.key),
            settingsBox("Чаты", "Темы", Icons.chat),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Вы точно хотите удалить все данные со своего аккаунта?",
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Отмена")),
                              TextButton(
                                  onPressed: () async {
                                    String uid =
                                        await _localStorageService.getUserUid();
                                    BlocProvider.of<ChatBloc>(context).add(
                                        DeleteAccountAndChatsEvent(
                                            userId: uid));
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => StartScreen()),(Route<dynamic> route) => false);
                                    
                                  },
                                  child: Text("Удалить"))
                            ],
                          );
                        });
                  },
                  child: Text("Выйти и удалить все данные")),
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}
