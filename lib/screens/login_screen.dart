import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/user_model.dart';
import 'group_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  Future<void> _attemptLogin() async {
    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    final users = await MockDataService.loadUsers();
    final enteredPhone = _phoneController.text.trim();
    final enteredPass = _passwordController.text;

    final matchedUser = users.firstWhere(
      (user) =>
          user.phone == enteredPhone && user.password == enteredPass,
      orElse: () => UserModel(id: '', phone: '', password: '', name: ''),
    );

    setState(() {
      _isLoading = false;
    });

    if (matchedUser.id.isEmpty) {
      setState(() {
        _errorText = 'Invalid phone number or password.';
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const GroupListScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            if (_errorText != null)
              Text(_errorText!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _attemptLogin,
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
