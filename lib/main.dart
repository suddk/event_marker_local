import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/service_locator.dart';

void main() {
  ServiceLocator.setup(useMock: true); // ← Switch to false later for API
  runApp(const EventApp());
}

class EventApp extends StatelessWidget {
  const EventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Marker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
