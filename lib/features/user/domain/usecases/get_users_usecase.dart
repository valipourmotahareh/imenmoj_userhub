import 'package:imenmoj_userhub/features/user/data/models/user_model.dart';
import 'package:imenmoj_userhub/features/user/domain/repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<UserModel>> call() => repository.getUsers();
}
