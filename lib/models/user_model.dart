class UserModel {
  final String id;
  final String name;
  final String phone;
  final String password;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.password,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'phone': phone,
        'password': password,
        'isAdmin': isAdmin,
      };
}
