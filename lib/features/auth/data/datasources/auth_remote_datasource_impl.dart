import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class AuthRemoteDataSourceImpl {
  final Account _account;
  final Databases _databases;

  static const String databaseId = '681a435200337485b362';
  static const String collectionId = '681a4367001c06b230aa';

  AuthRemoteDataSourceImpl(Client client)
    : _account = Account(client),
      _databases = Databases(client);

  Future<models.User> register({
    required String email,
    required String password,
    required String name,
    String? avatarUrl,
  }) async {
    try {
      ///Create an account
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      /// Check and delete active sessions if any.
      try {
        await _account.createEmailPasswordSession(
          email: email,
          password: password,
        );
      } on AppwriteException catch (e) {
        if (e.code == 401 &&
            e.message?.contains('session is active.') == true) {
          await _account.deleteSessions();
          await _account.createEmailPasswordSession(
            email: email,
            password: password,
          );
        } else {
          rethrow;
        }
      }

      /// Creating a document in the database
      await _databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: user.$id,
        data: {'name': name, 'email': email, 'avatarUrl': avatarUrl ?? ''},
        permissions: [
          Permission.read(Role.user(user.$id)),
          Permission.update(Role.user(user.$id)),
        ],
      );

      return user;
    } on AppwriteException catch (e) {
      print('AppwriteException: ${e.message}');
      rethrow;
    } catch (e) {
      print('Exception: $e');
      rethrow;
    }
  }

  Future<models.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      if (e.code == 401 && e.message?.contains('session is active.') == true) {
        ///If the session is active, first clear all sessions and try again.
        await _account.deleteSessions();
        return await _account.createEmailPasswordSession(
          email: email,
          password: password,
        );
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }

  Future<models.User?> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (_) {
      return null;
    }
  }
}
