import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/components/find_user.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/screens/find_new_users.dart';
import 'package:chat_app/components/list_tile_user_dialog.dart';
import 'package:chat_app/screens/settings_screen.dart';
import 'package:chat_app/utils/images.dart';
import 'package:chat_app/utils/local_database.dart';
import 'package:chat_app/utils/user_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> ls = ["Test", "Test"];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatBloc>(context).add(SubcribeToAllChatEvent());
    getInfo().then((value) => {
          if (mounted)
            setState(() {
              ls = value;
            })
        });
    // final box = Hive.box<UserModelToHive>("lastMessages");
    // print("Box length: ${box.length}");
    // box.watch().listen((event) {
    //   print("Hive box changed");
    //   final allLastMessages = box.values.toList();
    //   print("All last messages: $allLastMessages");

    // });
  }

  Future<List<String>> getInfo() async {
    LocalStorageService _localStorageService = LocalStorageService();
    List<String> ln = await _localStorageService.getUserInfo();
    ls = ln;
    return ln;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Отчистка hive. удалить.
          // final box = Hive.box<UserModelToHive>("lastMessages");
          // await box.clear();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => FindNewUsers()));
        },
        child: Icon(
          Icons.person_add,
          size: 30,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("${ls[0]} ${ls[1]} ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
            .paddingAll(8),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingScreen()));
              },
              icon: Icon(Icons.settings)),
          12.width
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(background_chats), fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              // FindUser(),        //Нет поисковой строки, исправить

              Expanded(
                child: ValueListenableBuilder<Box<UserModelToHive>>(
                  valueListenable:
                      Hive.box<UserModelToHive>("lastMessages").listenable(),
                  builder: (context, box, _) {
                    final messages = box.values.toList();
                    if (messages.isEmpty) {
                      return Center(child: Text("Выберите себе собеседника"));
                    }
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ListTileUserDialog(
                          unicNickName: message.unicNickName,
                          uid: message.uid,
                          name: message.name,
                          surname: message.surname,
                          isRead: message.isRead,
                          lastMessage: message.lastMessage,
                          timestamp: message.timeStamp,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
