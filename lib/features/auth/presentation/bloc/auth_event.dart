import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String avatarUrl;

  const RegisterRequested(this.email, this.password, this.name,this.avatarUrl);

  @override
  List<Object?> get props => [email, password, name];
}

class LogoutRequested extends AuthEvent {}
