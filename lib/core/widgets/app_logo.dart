import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

/// The Offpick mark: a gradient ring with a price tag and three sparks.
class AppLogoMark extends StatelessWidget {
  final double size;

  const AppLogoMark({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomPaint(size: Size.square(size), painter: LogoPainter(isDark: isDark));
  }
}

/// Mark + "ffpick" text, the ring reads as the "O".
class AppWordmark extends StatelessWidget {
  final double fontSize;
  final Color? textColor;

  const AppWordmark({super.key, this.fontSize = 40, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
          offset: Offset(0, -fontSize * 0.12),
          child: AppLogoMark(size: fontSize * 1.32),
        ),
        Transform.translate(
          offset: Offset(-fontSize * 0.2, 0),
          child: Text(
            'ffpick',
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -fontSize * 0.04,
              height: 1,
              color: textColor ?? context.colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Draws the mark on a 100 x 100 grid and scales it to the given size.
/// The bright lime version is for dark backgrounds; on light backgrounds
/// the mark uses deeper greens so it stays visible.
class LogoPainter extends CustomPainter {
  final bool isDark;

  LogoPainter({required this.isDark});

  List<Color> get ringColors => isDark
      ? const [AppColors.logoYellow, Color(0xFF9BE53B), AppColors.logoGreen]
      : const [Color(0xFF9ACD10), Color(0xFF4CB52E), Color(0xFF15803D)];

  Color get tagColor => isDark ? const Color(0xFFDDF23A) : const Color(0xFF3D9A1E);

  Color get sparkColor => isDark ? const Color(0xFFD4EE33) : const Color(0xFF7DB51A);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    canvas.save();
    canvas.scale(scale);

    const center = Offset(40, 60);
    const ringRadius = 28.5;
    const ringWidth = 15.0;

    final ringRect = Rect.fromCircle(center: center, radius: ringRadius + ringWidth);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: ringColors,
      ).createShader(ringRect);
    canvas.drawCircle(center, ringRadius, ringPaint);

    drawTag(canvas, center);
    drawSparks(canvas);
    canvas.restore();
  }

  void drawTag(Canvas canvas, Offset center) {
    final tagPaint = Paint()
      ..color = tagColor
      ..style = PaintingStyle.fill;
    final cornerPaint = Paint()
      ..color = tagColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round;

    // A tag pointing straight up, later rotated so it points to the top right.
    final tag = Path()
      ..moveTo(-7, 11)
      ..lineTo(-7, -3)
      ..lineTo(0, -11)
      ..lineTo(7, -3)
      ..lineTo(7, 11)
      ..close();

    canvas.saveLayer(Rect.fromCircle(center: center, radius: 30), Paint());
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4);
    canvas.drawPath(tag, tagPaint);
    canvas.drawPath(tag, cornerPaint);
    canvas.drawCircle(const Offset(0, -3.5), 2.4, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  void drawSparks(Canvas canvas) {
    final sparkPaint = Paint()
      ..color = sparkColor
      ..strokeWidth = 4.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(63, 17), const Offset(66, 5), sparkPaint);
    canvas.drawLine(const Offset(71, 24), const Offset(80, 16), sparkPaint);
    canvas.drawLine(const Offset(76, 32), const Offset(88, 32), sparkPaint);
  }

  @override
  bool shouldRepaint(covariant LogoPainter oldDelegate) => oldDelegate.isDark != isDark;
}
