import 'package:flutter/material.dart';
import 'screens/settings_screen.dart';


void main() {
  runApp(const TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SettingsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
