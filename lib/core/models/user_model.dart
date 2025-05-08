class UserModel {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'profileImageUrl': profileImageUrl};
  }
}
