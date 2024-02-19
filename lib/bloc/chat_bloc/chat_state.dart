part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class StartDialogState extends ChatState {}

final class ChatIsNotFoundState extends ChatState {

}

final class ChatCreateState extends ChatState {
    String chatId;
  ChatCreateState({required this.chatId});
}

final class ChatFoundState extends ChatState {
  String chatId;
  ChatFoundState({required this.chatId});
}



final class ShowAllDialogHomeScreenState extends ChatState {}

final class ZeroLastMessageInfoState extends ChatState {}

final class ErrorFindUsersState extends ChatState {}

final class ShowAllUsersToFindState extends ChatState {
  List<UserModel> listUsers;

  ShowAllUsersToFindState({required this.listUsers});
}

final class ShowAllMessageInDialogState extends ChatState {
  List<Message> listMessage;
  ShowAllMessageInDialogState({required this.listMessage});
}
