import 'dart:async';
import 'dart:math';
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

    // Blob animation controller (loops forever)
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
          // Morphing blob
          Positioned.fill(
            child: CustomPaint(
              painter: MorphingBlobPainter(
                progress: progress,
                time: blobTime,
              ),
            ),
          ),

          // Timer text
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

      // Buttons
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

// ------------------------------------------------------------
// Morphing Blob Painter
// ------------------------------------------------------------

class MorphingBlobPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0
  final double time;     // animation time

  MorphingBlobPainter({
    required this.progress,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFBE0C)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Height of the blob based on timer progress
    final blobHeight = size.height * progress;

    // Start bottom-left
    path.moveTo(0, size.height);

    // Move up left side
    path.lineTo(0, size.height - blobHeight);

    // Draw wavy top
    final int points = 2;
    for (int i = 0; i <= points; i++) {
      final x = size.width * (i / points);

      // Organic wobble using sin waves
      final wobble = sin((i * 0.8) + time * 1.0) * 20;

      final y = size.height - blobHeight + wobble;

      path.lineTo(x, y);
    }

    // Down right side
    path.lineTo(size.width, size.height);

    // Close shape
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MorphingBlobPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.time != time;
  }
}
