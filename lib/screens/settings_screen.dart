import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'timer_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int sets = 5;
  int workSeconds = 30;
  int restSeconds = 5;

// for implementing cusotmized names in the future
  String exerciseName = "Workout";

  void increment(String field) {
    setState(() {
      switch (field) {
        case "sets":
          sets++;
          break;
        case "work":
          workSeconds += 5;
          break;
        case "rest":
          restSeconds += 5;
          break;
      }
    });
  }

  void decrement(String field) {
    setState(() {
      switch (field) {
        case "sets":
          if (sets > 1) sets--;
          break;
        case "work":
          if (workSeconds > 5) workSeconds -= 5;
          break;
        case "rest":
          if (restSeconds > 0) restSeconds -= 5;
          break;
      }
    });
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  void startTimer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SimpleTimerScreen(
          sets: sets,
          workDuration: workSeconds,
          restDuration: restSeconds,
          exerciseName: exerciseName,
        ),
      ),
    );
  }

Widget buildSettingRow(String label, String value, String field) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.baloo2(
            fontSize: 28,
            color: Colors.black87,
            height: 0.8,
          ),
        ),

        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => decrement(field),
                icon: const Icon(Icons.remove_circle),
                iconSize: 48,
                color: Colors.black,
              ),
              const SizedBox(width: 14),
              Text(
                value,
                style: GoogleFonts.baloo2(
                  fontSize: 72,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 14),
              IconButton(
                onPressed: () => increment(field),
                icon: const Icon(Icons.add_circle),
                iconSize: 48,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: [
            buildSettingRow("sets", "$sets", "sets"),
            buildSettingRow("work", formatTime(workSeconds), "work"),
            buildSettingRow("rest", formatTime(restSeconds), "rest"),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: startTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text("Start", style: GoogleFonts.baloo2(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
