import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:imenmoj_userhub/features/user/data/data_sources/user_local_datasource.dart';
import 'package:imenmoj_userhub/features/user/data/data_sources/user_remote_datasource.dart';
import 'package:imenmoj_userhub/features/user/data/models/user_model.dart';
import 'package:imenmoj_userhub/features/user/domain/repositories/user_repository.dart';

import '../../domain/entities/user_entity.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;


  UserRepositoryImpl({required this.remoteDataSource,required this.localDataSource});

  @override
  Future<List<UserModel>> getUsers() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      final userModels = await remoteDataSource.fetchUsers();
      await localDataSource.cacheUsers(userModels);
      return userModels;
    } else {
      final cachedUsers = await localDataSource.getCachedUsers();
      return cachedUsers;
    }
  }


  @override
  Future<User> getUserById(String id) async {
    final userModel = await remoteDataSource.fetchUserById(id);
    return userModel.toEntity();
  }

  @override
  Future<void> createUser(UserModel user) async {
    final userModel = UserModel.fromEntity(user);
    await remoteDataSource.createUser(userModel);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final userModel = UserModel.fromEntity(user);
    await remoteDataSource.updateUser(userModel);
  }

  @override
  Future<void> deleteUser(String id) async {
    await remoteDataSource.deleteUser(id);
  }
}
