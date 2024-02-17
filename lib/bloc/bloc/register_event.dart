part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class CheckAndAuthorUserEvent extends RegisterEvent {}

class RegisterUserEvent extends RegisterEvent {}
