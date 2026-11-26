class UserModel {
  static const String collectionName = 'Users';

  String id;
  String name;
  String email;
  String phone;
  int avatarId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.avatarId = 1,
  });

  UserModel.fromFireStore(Map<String, dynamic>? data)
      : this(
    id: data?['id']?.toString() ?? '',
    name: data?['name']?.toString() ?? '',
    email: data?['email']?.toString() ?? '',
    phone: data?['phone']?.toString() ?? '',
    avatarId: (data?['avatarId'] as num?)?.toInt() ?? 1,
  );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarId': avatarId,
    };
  }
}