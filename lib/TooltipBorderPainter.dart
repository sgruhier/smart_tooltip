import 'package:flutter/material.dart';

import 'smartTooltip.dart';

class TooltipBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final TooltipPosition position;
  final double width;
  final double height;

  TooltipBorderPainter({
    required this.borderColor,
    this.borderWidth = 2.0,
    required this.position,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final Path path = Path();

    // Tooltip border drawing logic
    switch (position) {
      case TooltipPosition.top:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(width / 2 - 10, height);
        path.lineTo(width / 2, height + 10);
        path.lineTo(width / 2 + 10, height);
        break;
      case TooltipPosition.bottom:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(width / 2 - 10, 0);
        path.lineTo(width / 2, -10);
        path.lineTo(width / 2 + 10, 0);
        break;
      case TooltipPosition.left:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(width, height / 2 - 10);
        path.lineTo(width + 10, height / 2);
        path.lineTo(width, height / 2 + 10);
        break;
      case TooltipPosition.right:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(0, height / 2 - 10);
        path.lineTo(-10, height / 2);
        path.lineTo(0, height / 2 + 10);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
