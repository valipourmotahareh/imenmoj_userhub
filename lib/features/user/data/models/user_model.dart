import 'package:hive/hive.dart';

import '../../domain/entities/user_entity.dart' show User;

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }

  // افزودن متد toEntity برای تبدیل به موجودیت دامنه
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }

  // افزودن متد fromEntity برای تبدیل موجودیت دامنه به مدل داده‌ای
  factory UserModel.fromEntity(UserModel user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
