import 'package:imenmoj_userhub/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password, String name,String avatarUrl);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
