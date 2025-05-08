import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserLocalDataSource {
  final Box<UserModel> userBox = Hive.box<UserModel>('users');

  Future<void> cacheUsers(List<UserModel> users) async {
    await userBox.clear();
    for (var user in users) {
      await userBox.put(user.id, user);
    }
  }

  Future<List<UserModel>> getCachedUsers() async {
    return userBox.values.toList();
  }
}
