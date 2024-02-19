// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class FindLastMessageUsersEvent extends ChatEvent {
  String userNickName;
  FindLastMessageUsersEvent({
    required this.userNickName,
  });

}
class FindNewUserEvent extends ChatEvent {
  String symbolToFind;
  FindNewUserEvent({
    required this.symbolToFind,
  });

}

class StartDialogEvent extends ChatEvent {}


class AddNewMessageEvent extends ChatEvent {
  //для получения uid собеседника и быстрому доступу к ключу
  UserModel userModel;
  
  String newMessage;
  AddNewMessageEvent({required this.newMessage, required this.userModel});
}


class AddOrReturnChatEvent extends ChatEvent {
  //для создания нового чата
  UserModel userModel;
   AddOrReturnChatEvent({required this.userModel});

}
class ShowAllMessageInDialogEvent extends ChatEvent {
  //для создания нового чата
  UserModel userModel;
   ShowAllMessageInDialogEvent({required this.userModel});

}

class SubcribeToAllChatEvent extends ChatEvent {
  
}

class SubscribeToAllMessageEvent extends ChatEvent {}

class ShowAllDialogHomeScreenEvent extends ChatEvent {}

