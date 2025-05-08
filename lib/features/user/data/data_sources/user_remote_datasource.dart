import 'package:appwrite/appwrite.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  final Databases _databases;
  final String _databaseId;
  final String _collectionId;

  UserRemoteDataSource({
    required Client client,
    required String databaseId,
    required String collectionId,
  })  : _databases = Databases(client),
        _databaseId = databaseId,
        _collectionId = collectionId;

  Future<List<UserModel>> fetchUsers() async {
    final response = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _collectionId,
    );

    return response.documents
        .map((doc) => UserModel.fromMap(doc.data))
        .toList();
  }

  Future<UserModel> fetchUserById(String id) async {
    final response = await _databases.getDocument(
      databaseId: _databaseId,
      collectionId: _collectionId,
      documentId: id,
    );

    return UserModel.fromMap(response.data);
  }

  Future<void> createUser(UserModel user) async {
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _collectionId,
      documentId: ID.unique(),
      data: user.toMap(),
    );
  }

  Future<void> updateUser(UserModel user) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _collectionId,
      documentId: user.id,
      data: user.toMap(),
    );
  }

  Future<void> deleteUser(String id) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: _collectionId,
      documentId: id,
    );
  }
}
