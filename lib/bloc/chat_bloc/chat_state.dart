part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChengeUserToDialogState extends ChatState {}

final class ChangeAllLastMessageInfoState extends ChatState {
  LastMessageInfo lastMessageInfo;

  ChangeAllLastMessageInfoState({required this.lastMessageInfo});

}

final class ZeroLastMessageInfoState extends ChatState {}

final class ErrorFindUsersState extends ChatState{}

final class ShowAllUsersToFindState extends ChatState {

  List<UserModel> listUsers;

  ShowAllUsersToFindState({required this.listUsers});

}