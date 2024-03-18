// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/utils/images.dart';
import 'package:chat_app/utils/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/utils/widgets.dart';

class DialogScreen extends StatefulWidget {
  String companionUid;
  String companionName;
  String companionSurname;
  String unicNickName;
  bool activity;
  Map<String, String> chat;
  String? aboutMe;
  Timestamp lastSeen;
  String? chatId;
  String? myUid;

  DialogScreen(
      {Key? key,
      required this.companionUid,
      required this.companionName,
      required this.companionSurname,
      required this.unicNickName,
      required this.activity,
      required this.chat,
      this.aboutMe,
      required this.lastSeen,
      this.chatId,
      required this.myUid})
      : super(key: key);

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  // String myUid = "";

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeAsync();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String myUid = widget.myUid!;
    String companionName = widget.companionName;
    String companionSurname = widget.companionSurname;
    String companionUid = widget.companionUid;
    UserModel model = UserModel(
        uid: widget.companionUid,
        unicNickName: widget.unicNickName,
        name: widget.companionName,
        surname: widget.companionSurname,
        activity: true,
        chat: {},
        lastSeen: widget.lastSeen);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(120, 246, 216, 107),
        elevation: 0,
        leading: IconButton(
            onPressed: () async {
              BlocProvider.of<ChatBloc>(context).add(UnsubscribeDialogEvent());
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.keyboard_arrow_left)),
        title: Row(
          children: [
            showUser(companionName, companionSurname),
            8.width,
            Text("${companionName} ${companionSurname}",
                style: TextStyle(fontSize: 22)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.attachment),
              hoverColor: Color.fromARGB(255, 218, 217, 217),
            ),
            Expanded(
              child: TextFormField(
                // validator: (value) {if (value == null || value.isEmpty) return "Отказано"; else {return null;}},
                controller: controller,
                decoration: InputDecoration(
                    hintText: "Сообщение",
                    filled: true,
                    fillColor: Color.fromARGB(255, 218, 217, 217)),
              ),
            ),
            IconButton(
              onPressed: () {
                if (controller.text.length >= 1) {
                  BlocProvider.of<ChatBloc>(context).add(AddNewMessageEvent(
                      newMessage: controller.text, userModel: model));
                  controller.text = "";
                }
              },
              icon: Icon(Icons.send),
              hoverColor: Color.fromARGB(255, 218, 217, 217),
            )
          ],
        ).paddingBottom(8),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(background_dialog), fit: BoxFit.cover)),
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is StartDialogState) {
              BlocProvider.of<ChatBloc>(context)
                  .add(ShowAllMessageInDialogEvent(userModel: model));
            } else if (state is ChatFoundState) {
              widget.chatId = state.chatId;
              BlocProvider.of<ChatBloc>(context)
                  .add(ShowAllMessageInDialogEvent(
                userModel: model,
              ));
            } else if (state is ChatCreateState) {
              widget.chatId = state.chatId;
              BlocProvider.of<ChatBloc>(context).add(
                  ShowAllMessageInDialogEvent(
                      userModel: UserModel(
                          uid: widget.companionUid,
                          unicNickName: widget.unicNickName,
                          name: widget.companionName,
                          surname: widget.companionSurname,
                          activity: true,
                          chat: {},
                          lastSeen: Timestamp.now())));
            } else if (state is ChatFoundState) {
            } else if (state is ShowAllMessageInDialogState) {}
          },
          builder: (context, state) {
            if (state is StartDialogState) {
              return CircularProgressIndicator();
            } else if (state is ChatFoundState) {
              return CircularProgressIndicator();
            } else if (state is ChatIsNotFoundState) {
              return Center(child: Text("Отправьте ваше первое сообщение!"));
            } else if (state is ShowAllMessageInDialogState
                // ||
                //     state is ChatFoundState
                ) {
              if (state.listMessage.isNotEmpty) {
                return ListView.builder(
                  reverse: true,
                  itemCount: state.listMessage.length,
                  itemBuilder: (context, index) {
                    final message = state.listMessage[index];
                    return Align(
                      alignment: message.senderId == myUid
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: message.senderId == myUid
                                ? Colors.blue[200]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: message.senderId == myUid
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: TextStyle(fontSize: 16),
                              ),
                              4.height,
                              Text(
                                DateFormat("dd MMM kk:mm")
                                    .format(message.timestamp.toDate()),
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text("Напишите новое сообщение"));
              }
            } else {
              return Center(child: Text("Ошибка"));
            }
          },
        ),
      ),
    );
  }

  Future<void> initializeAsync() async {
    LocalStorageService _localStorageService = LocalStorageService();
    widget.chatId = await _localStorageService.getChatId(widget.companionUid);
    // myUid = await _localStorageService.getUserUid();

    if (widget.chatId == null) {
      BlocProvider.of<ChatBloc>(context)
          .add(AddOrReturnChatEvent(companionUid: widget.companionUid));
    } else {
      BlocProvider.of<ChatBloc>(context).add(ShowAllMessageInDialogEvent(
          userModel: UserModel(
              uid: widget.companionUid,
              unicNickName: widget.unicNickName,
              name: widget.companionName,
              surname: widget.companionSurname,
              activity: true,
              chat: {},
              lastSeen: Timestamp.now())));
      // }
    }
    print("f");
  }
}
