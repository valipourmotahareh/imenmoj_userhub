import 'package:imenmoj_userhub/features/user/data/models/user_model.dart';

import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers();
  Future<User> getUserById(String id);
  Future<void> createUser(UserModel user);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}