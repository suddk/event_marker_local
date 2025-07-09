import 'dart:convert';
import 'package:flutter/services.dart';

class AuthService {
  Future<Map<String, dynamic>?> signInWithPhoneAndPassword(
      String phone, String password) async {
    final String userJson = await rootBundle.loadString('assets/users.json');
    final List<dynamic> users = json.decode(userJson);

    for (var user in users) {
      if (user['phone'] == phone && user['password'] == password) {
        return user;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> registerWithPhoneAndPassword(
      String name, String phone, String password) async {
    // Simulated registration logic — no persistence
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'phone': phone,
      'password': password
    };
  }

  Future<void> signOut() async {
    // No-op for mock
  }

  Future<Map<String, dynamic>?> getUserProfile(String phone) async {
    final String userJson = await rootBundle.loadString('assets/users.json');
    final List<dynamic> users = json.decode(userJson);

    return users.firstWhere((u) => u['phone'] == phone, orElse: () => null);
  }
}
