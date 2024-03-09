import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/components/find_user.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/screens/find_new_users.dart';
import 'package:chat_app/components/list_tile_user_dialog.dart';
import 'package:chat_app/utils/user_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    print("HomeScreen initState");
    BlocProvider.of<ChatBloc>(context).add(SubcribeToAllChatEvent());
    // final box = Hive.box<UserModelToHive>("lastMessages");
    // print("Box length: ${box.length}");
    // box.watch().listen((event) {
    //   print("Hive box changed");
    //   final allLastMessages = box.values.toList();
    //   print("All last messages: $allLastMessages");

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          size: 25,
        ),
      ),
      appBar: AppBar(
        title: Text("Чаты",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
            .paddingAll(8),
      ),
      body: SafeArea(
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
    );
  }
}
