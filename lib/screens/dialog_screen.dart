import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class DialogScreen extends StatefulWidget {
  UserModel userModel;
  // Chat? chat;
  // List<Message>? messages;
  // LastMessageInfo? lastMessageInfo;
  // this.chat, this.messages,
  DialogScreen({super.key, required this.userModel});

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  final TextEditingController controller =
      TextEditingController(); 

  @override
  void initState() {
    super.initState();
  BlocProvider.of<ChatBloc>(context).add(ShowAllMessageInDialogEvent(userModel: widget.userModel));

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
        leading: showUser(widget.userModel.name, widget.userModel.surname),
        title: Text("${widget.userModel.name} ${widget.userModel.surname}",
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
                onSubmitted: (text) {
                  if (text.isNotEmpty) {
                    BlocProvider.of<ChatBloc>(context).add(AddNewMessageEvent(
                        newMessage: text, userModel: widget.userModel));
                    controller.clear(); 
                  }
                },
                controller: controller,
                decoration: InputDecoration(
                    hintText: "Сообщение",
                    filled: true,
                    fillColor: Color.fromARGB(255, 218, 217, 217)),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.keyboard_voice),
              hoverColor: Color.fromARGB(255, 218, 217, 217),
            )
          ],
        ).paddingBottom(8),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is StartDialogState) {
            BlocProvider.of<ChatBloc>(context)
                .add(ShowAllMessageInDialogEvent(userModel: widget.userModel));
          } else if (state is StartShowMessageState)
          {}
        },
        builder: (context, state) {
          if (state is StartDialogState) {
            return CircularProgressIndicator();
          } else if (state is ChatIsNotFoundState) {
            return Center(child: Text("Отправьте ваше первое сообщение!"));
          } else if (state is ShowAllMessageInDialogState) {
            //Именно тут будем просматривать постоянно обновляющиеся сообщения
            // Здесь должна быть логика отображения сообщений
            return ListView.builder(
              itemCount: state.listMessage.length,
              itemBuilder:(context, index) {
                final message = state.listMessage[index];
                return ListTile(
                  title: Text(message.text),
                  subtitle: Text(DateFormat("dd MMM kk:mm").format(message.timestamp.toDate())),
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
