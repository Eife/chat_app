// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class FindUsersEvent extends ChatEvent {
  String userNickName;
  FindUsersEvent({
    required this.userNickName,
  });

}
