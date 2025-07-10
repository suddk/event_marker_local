class UserModel {
  final String id;
  final String name;
  final String phone;
  final String password;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      phone: json['phone'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'password': password,
    };
  }
}
