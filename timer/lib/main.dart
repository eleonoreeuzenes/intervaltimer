import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SimpleTimerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SimpleTimerScreen extends StatefulWidget {
  const SimpleTimerScreen({super.key});

  @override
  State<SimpleTimerScreen> createState() => _SimpleTimerScreenState();
}

class _SimpleTimerScreenState extends State<SimpleTimerScreen> {
  static const int initialSeconds = 60;
  int remainingSeconds = initialSeconds;
  Timer? timer;

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        t.cancel();
      }
    });
  }

  void resetTimer() {
    setState(() {
      remainingSeconds = initialSeconds;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          formatTime(remainingSeconds),
          style: GoogleFonts.baloo2(
            fontSize: 140,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "start",
            onPressed: startTimer,
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "reset",
            onPressed: resetTimer,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
