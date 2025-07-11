import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/service_locator.dart';
import 'group_list_screen.dart';
import '../services/session_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  try {
    final users = await ServiceLocator.dataService.loadUsers();
    final user = users.firstWhere(
      (u) =>
          u.phone == _phoneController.text.trim() &&
          u.password == _passwordController.text.trim(),
      orElse: () => UserModel(
        id: '',
        name: '',
        phone: '',
        password: '',
        isAdmin: false, 
      ),
    );


    if (user.id.isEmpty) {
      setState(() {
        _errorMessage = 'Invalid phone or password';
        _isLoading = false;
      });
      return;
    }

    // ✅ Store the full user object in session
    SessionService.login(user);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const GroupListScreen(),
      ),
    );

    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed: $e';
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
