import 'package:flutter/material.dart';

import '../utils/app_icons.dart';

/// Shows an icon by its API name. Lucide icons are used where they exist,
/// jeans and shoes are drawn by hand in the same line style.
class AppIcon extends StatelessWidget {
  final String iconKey;
  final double size;
  final Color? color;

  const AppIcon(this.iconKey, {super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? IconTheme.of(context).color ?? Colors.black;
    if (AppIcons.customKeys.contains(iconKey)) {
      return CustomPaint(
        size: Size.square(size),
        painter: LineIconPainter(iconKey: iconKey, color: iconColor),
      );
    }
    return Icon(AppIcons.of(iconKey), size: size, color: iconColor);
  }
}

class LineIconPainter extends CustomPainter {
  final String iconKey;
  final Color color;

  LineIconPainter({required this.iconKey, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (iconKey == 'jeans') {
      final legs = Path()
        ..moveTo(6, 3)
        ..lineTo(18, 3)
        ..lineTo(19, 21)
        ..lineTo(14.5, 21)
        ..lineTo(12, 10)
        ..lineTo(9.5, 21)
        ..lineTo(5, 21)
        ..close();
      canvas.drawPath(legs, paint);
      canvas.drawLine(const Offset(6, 6.5), const Offset(18, 6.5), paint);
    } else {
      final shoe = Path()
        ..moveTo(3, 8)
        ..lineTo(7, 8)
        ..lineTo(8.5, 10.5)
        ..lineTo(13.5, 12.2)
        ..lineTo(18.5, 13.4)
        ..quadraticBezierTo(21, 14.2, 21, 16.5)
        ..lineTo(21, 17.5)
        ..lineTo(3, 17.5)
        ..close();
      canvas.drawPath(shoe, paint);
      canvas.drawLine(const Offset(3, 20.5), const Offset(21, 20.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant LineIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.iconKey != iconKey;
  }
}
