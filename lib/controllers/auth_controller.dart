import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? currentUser;

  Future<bool> login(String phone, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.signInWithPhoneAndPassword(phone, password);
      if (user != null) {
        currentUser = user;
        error = null;
        return true;
      } else {
        error = 'Invalid phone or password';
        return false;
      }
    } catch (e) {
      error = 'Login failed: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}
