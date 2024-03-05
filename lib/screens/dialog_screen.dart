import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class DialogScreen extends StatefulWidget {
  UserModel? userModel;
  DialogScreen({super.key, required this.userModel});

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  final TextEditingController controller = TextEditingController();
  String chatId = "";
  late UserModel model;

  @override
  void initState() {
    super.initState();


    if (widget.userModel != null) {
      model = widget.userModel!;
      BlocProvider.of<ChatBloc>(context)
          .add(AddOrReturnChatEvent(userModel: widget.userModel!));
    } else {
      var box = Hive.box<UserModelToHive>("lastMessages");
      UserModelToHive existingData = box.get(chatId)!;
      UserModelToHive usmth = existingData;
      UserModel data = UserModel(
          uid: existingData.uid,
          unicNickName: usmth.unicNickName,
          name: usmth.name,
          surname: usmth.surname,
          activity: usmth.activity,
          chat: usmth.chat,
          lastSeen: Timestamp.now());
      model = data;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showUser(model.name, model.surname),
        title: Text("${model.name} ${model.surname}",
            style: TextStyle(fontSize: 22)),
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
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: "Сообщение",
                    filled: true,
                    fillColor: Color.fromARGB(255, 218, 217, 217)),
              ),
            ),
            IconButton(
              onPressed: () {
                BlocProvider.of<ChatBloc>(context).add(AddNewMessageEvent(
                    newMessage: controller.text, userModel: model));
              },
              icon: Icon(Icons.send),
              hoverColor: Color.fromARGB(255, 218, 217, 217),
            )
          ],
        ).paddingBottom(8),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is StartDialogState) {
            BlocProvider.of<ChatBloc>(context)
                .add(ShowAllMessageInDialogEvent(userModel: model));
          } else if (state is ChatFoundState) {
            chatId = state.chatId;
            BlocProvider.of<ChatBloc>(context).add(ShowAllMessageInDialogEvent(
              userModel: model,
            ));
          } else if (state is ChatCreateState) {
            chatId = state.chatId;
          }
        },
        builder: (context, state) {
          if (state is StartDialogState) {
            return CircularProgressIndicator();
          } else if (state is ChatIsNotFoundState) {
            return Center(child: Text("Отправьте ваше первое сообщение!"));
          } else if (state is ShowAllMessageInDialogState) {
            //Именно тут будем просматривать постоянно обновляющиеся сообщения
            // Здесь должна быть логика отображения сообщений
            //Пока что обновления не привязано к онлайн поиском всех сообщений, и все же

            //Бокс потом убрать и получать через state

            return ListView.builder(
              itemCount: state.listMessage.length,
              itemBuilder: (context, index) {
                final message = state.listMessage[index];
                return ListTile(
                  title: Text(message.text),
                  subtitle: Text(DateFormat("dd MMM kk:mm")
                      .format(message.timestamp.toDate())),
                );
              },
            );
          } else {
            return Text("Ошибка");
          }
        },
      ),
    );
  }
}
