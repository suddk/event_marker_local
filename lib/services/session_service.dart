import '../models/user_model.dart';

class SessionService {
  static UserModel? currentUser;

  static void login(UserModel user) {
    currentUser = user;
  }

  static void logout() {
    currentUser = null;
  }

  static bool get isLoggedIn => currentUser != null;
  static bool get isAdmin => currentUser?.isAdmin ?? false;
  static UserModel? get loggedInUser => currentUser;
}


