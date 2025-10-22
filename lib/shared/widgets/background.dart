import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:taleem_ai/core/theme/app_colors.dart';

Widget buildEducationalBackground() {
  return Positioned.fill(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.03),
            AppColors.secondary.withOpacity(0.02),
            AppColors.background,
          ],
        ),
      ),
      child: CustomPaint(painter: EducationalBackgroundPainter()),
    ),
  );
}

// Custom Painter for Educational Background
class EducationalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid pattern first
    _drawGridPattern(canvas, size);
    // Draw math symbols on top
    _drawMathSymbols(canvas, size);
  }

  void _drawMathSymbols(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr, // Add this!
    );

    // Mathematical symbols
    final symbols = [
      // '∪',
      // '∩',
      // '⊆',
      // '⊂',
      // '∈',
      // '∅',
      // 'π',
      // '∑',
      // '∞',
      // '√',
      // '∫',
      // 'Δ',
    ];
    final random = Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < 25; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final symbol = symbols[random.nextInt(symbols.length)];
      final opacity = 0.08 + random.nextDouble() * 0.07; // Increased opacity

      textPainter.text = TextSpan(
        text: symbol,
        style: TextStyle(
          fontSize: 40 + random.nextDouble() * 30,
          color: AppColors.primary.withOpacity(opacity),
          fontWeight: FontWeight.w300,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  void _drawGridPattern(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = AppColors.primary.withOpacity(0.05); // Increased opacity

    // Draw subtle diagonal lines
    for (double i = -size.height; i < size.width; i += 80) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
