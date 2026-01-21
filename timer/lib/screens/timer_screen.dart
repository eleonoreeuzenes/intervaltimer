import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../widgets/blob_painter.dart';

class SimpleTimerScreen extends StatefulWidget {
  final int workDuration;
  final int restDuration;
  final String exerciseName;
  final int sets;

  const SimpleTimerScreen({
    super.key,
    required this.workDuration,
    required this.restDuration,
    required this.exerciseName,
    required this.sets,
  });

  @override
  State<SimpleTimerScreen> createState() => _SimpleTimerScreenState();
}

enum TimerPhase { work, rest, done }

class _SimpleTimerScreenState extends State<SimpleTimerScreen>
    with TickerProviderStateMixin {
  late int remainingSeconds;
  late int currentSet;
  late TimerPhase phase;
  Timer? timer;
  bool isRunning = false;

  late AnimationController blobController;
  double blobTime = 0.0;
  bool doneNavigated = false;

  @override
  void initState() {
    super.initState();
    currentSet = 1;
    phase = TimerPhase.work;
    remainingSeconds = widget.workDuration;

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
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        t.cancel();
        handlePhaseTransition();
      }
    });
  }

  void handlePhaseTransition() {
    if (phase == TimerPhase.work && widget.restDuration > 0) {
      setState(() {
        phase = TimerPhase.rest;
        remainingSeconds = widget.restDuration;
        startTimer();
      });
    } else if (currentSet < widget.sets) {
      setState(() {
        currentSet++;
        phase = TimerPhase.work;
        remainingSeconds = widget.workDuration;
        startTimer();
      });
    } else {
      setState(() {
        phase = TimerPhase.done;
      });
      Vibration.vibrate(
        pattern: [500, 200, 500], 
      );
    }
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      currentSet = 1;
      phase = TimerPhase.work;
      remainingSeconds = widget.workDuration;
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    if (phase == TimerPhase.done) {
      if (!doneNavigated) {
        doneNavigated = true;
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
      return Scaffold(
        backgroundColor: Colors.pinkAccent,
        body: Center(
          child: Text(
            "done",
            style: GoogleFonts.baloo2(
              fontSize: 80,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final totalDuration =
        phase == TimerPhase.work ? widget.workDuration : widget.restDuration;
    final progress = 1 - (remainingSeconds / totalDuration);
    final isWork = phase == TimerPhase.work;

    return Scaffold(
      backgroundColor: isWork ? Colors.white :  Color(0xFFF95607),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: MorphingBlobPainter(
                progress: progress,
                time: blobTime,
                color: isWork ? const Color(0xFFFFBE0C) : Colors.white,
                fromBottom: isWork,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Text(
                formatTime(remainingSeconds),
                style: GoogleFonts.baloo2(
                  fontSize: 100,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  height: 0.8,
                ),
              ),
              Text(
                isWork ? widget.exerciseName : "Rest",
                style: GoogleFonts.baloo2(
                  fontSize: 28,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Set $currentSet of ${widget.sets}",
                style: GoogleFonts.baloo2(
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              if (!isRunning)
                ElevatedButton(
                  onPressed: startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    "start",
                    style: GoogleFonts.baloo2(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: resetTimer,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
