class UserModel {
  final String id;
  final String phone;
  final String password;
  final String name;

  UserModel({
    required this.id,
    required this.phone,
    required this.password,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phone': phone,
      'password': password,
      'name': name,
    };
  }
}
