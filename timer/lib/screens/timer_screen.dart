import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/blob_painter.dart';

class SimpleTimerScreen extends StatefulWidget {
  const SimpleTimerScreen({super.key});

  @override
  State<SimpleTimerScreen> createState() => _SimpleTimerScreenState();
}

class _SimpleTimerScreenState extends State<SimpleTimerScreen>
    with TickerProviderStateMixin {
  static const int initialSeconds = 60;
  int remainingSeconds = initialSeconds;
  Timer? timer;

  late AnimationController blobController;
  double blobTime = 0.0;

  @override
  void initState() {
    super.initState();

    blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    blobController.addListener(() {
      setState(() {
        blobTime = blobController.value * 2 * pi;
      });
    });
  }

  @override
  void dispose() {
    blobController.dispose();
    timer?.cancel();
    super.dispose();
  }

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

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (remainingSeconds / initialSeconds);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: MorphingBlobPainter(
                progress: progress,
                time: blobTime,
              ),
            ),
          ),
          Center(
            child: Text(
              formatTime(remainingSeconds),
              style: GoogleFonts.baloo2(
                fontSize: 140,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
