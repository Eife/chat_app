// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class CheckAndAuthorUserEvent extends RegisterEvent {}

class RegisterUserEvent extends RegisterEvent {
  String name;
  String surname;
  String aboutMe;
  String unicNickName;
  RegisterUserEvent({
    required this.name,
    required this.unicNickName,
    required this.surname,
    required this.aboutMe,
  });
}

class CheckUnicalNickNameEvent extends RegisterEvent {
  String nickNameToCheck;
  CheckUnicalNickNameEvent({
    required this.nickNameToCheck,
  });
}
