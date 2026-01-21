import 'dart:math';
import 'package:flutter/material.dart';

class MorphingBlobPainter extends CustomPainter {
  final double progress;
  final double time;
   final Color color;
  final bool fromBottom;

  MorphingBlobPainter({
    required this.progress,
    required this.time,
        required this.color,
    required this.fromBottom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final blobHeight = size.height * progress;

    path.moveTo(0, size.height);
    path.lineTo(0, size.height - blobHeight);

    const int points = 2;
    for (int i = 0; i <= points; i++) {
      final x = size.width * (i / points);
      final wobble = sin((i * 0.8) + time * 1.0) * 20;
      final y = size.height - blobHeight + wobble;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MorphingBlobPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.time != time;
  }
}
