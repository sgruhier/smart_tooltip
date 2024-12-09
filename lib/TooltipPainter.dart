import 'package:flutter/material.dart';

import 'smartTooltip.dart';

class TooltipPainter extends CustomPainter {
  final String message;
  final Color backgroundColor;
  final TextStyle textStyle;
  final TooltipPosition position;
  final double width;
  final double height;

  TooltipPainter({
    required this.message,
    required this.backgroundColor,
    required this.textStyle,
    required this.position,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final Path path = Path();

    // Tooltip drawing logic
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

    // Draw text
    final TextSpan span = TextSpan(
      text: message,
      style: textStyle,
    );

    final TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      maxLines: 2,
    );
    textPainter.layout(maxWidth: width - 10); // Add padding to text

    textPainter.paint(canvas, Offset(10, (height - textPainter.height) / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
