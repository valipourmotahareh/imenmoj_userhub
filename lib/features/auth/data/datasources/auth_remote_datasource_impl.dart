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
      // ایجاد حساب کاربری
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // بررسی و حذف نشست‌های فعال در صورت وجود
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

      // ایجاد سند در دیتابیس
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
      // مدیریت خطاهای Appwrite
      print('AppwriteException: ${e.message}');
      rethrow;
    } catch (e) {
      // مدیریت سایر خطاها
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
        // اگر سشن فعال است، ابتدا همه سشن‌ها را پاک کن و دوباره تلاش کن
        await _account.deleteSessions();
        return await _account.createEmailPasswordSession(
          email: email,
          password: password,
        );
      }
      rethrow; // سایر خطاها را به بالا منتقل کن
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
