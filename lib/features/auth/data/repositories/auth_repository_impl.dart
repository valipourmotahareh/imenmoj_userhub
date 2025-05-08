import 'package:imenmoj_userhub/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:imenmoj_userhub/features/auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceImpl _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    final session = await _remoteDataSource.login(email: email, password: password);
    final user = await _remoteDataSource.getCurrentUser();
    return UserEntity(id: user!.$id, email: user.email, name: user.name);
  }

  @override
  Future<UserEntity> register(String email, String password, String name,String avatarUrl) async {
    final user = await _remoteDataSource.register(email: email, password: password, name: name,avatarUrl: avatarUrl);
    return UserEntity(id: user.$id, email: user.email, name: user.name);
  }

  @override
  Future<void> logout() async => await _remoteDataSource.logout();

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = await _remoteDataSource.getCurrentUser();
    if (user == null) return null;
    return UserEntity(id: user.$id, email: user.email, name: user.name);
  }
}
