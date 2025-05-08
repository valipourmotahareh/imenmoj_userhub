import 'package:equatable/equatable.dart';
import 'package:imenmoj_userhub/features/user/data/models/user_model.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUsersEvent extends UserEvent {}

class CreateUser extends UserEvent {
  final UserModel user;
  CreateUser(this.user);
}

class UpdateUser extends UserEvent {
  final UserModel user;
  UpdateUser(this.user);
}

class DeleteUser extends UserEvent {
  final String userId;
  DeleteUser(this.userId);
}
