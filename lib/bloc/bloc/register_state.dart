part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class UserEmptyState extends RegisterState {}

final class UserRegisterState extends RegisterState {
  UserModel user;

  UserRegisterState({required this.user});

}