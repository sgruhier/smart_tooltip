import 'package:flutter/material.dart';

import 'smartTooltip.dart';

/// A custom painter to draw a tooltip with a border and arrow indicating position.
class TooltipWithWidgetBorder extends CustomPainter {
  final Color borderColor; // The color of the tooltip border
  final TooltipPosition
      position; // Position of the tooltip (top, bottom, left, right)
  final double width; // Width of the tooltip
  final double height; // Height of the tooltip
  final double borderRadius; // Border radius of the tooltip

  TooltipWithWidgetBorder({
    required this.borderRadius,
    required this.borderColor,
    required this.position,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor // Set the border color
      ..style = PaintingStyle.fill; // Make the border filled

    final Path path = Path();

    // Tooltip shape drawing logic based on the position
    switch (position) {
      case TooltipPosition.top:
        // Draw the tooltip with a top-pointing arrow
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), Radius.circular(borderRadius)));
        path.moveTo(width / 2 - 10, height); // Left side of the arrow
        path.lineTo(width / 2, height + 10); // Arrow tip
        path.lineTo(width / 2 + 10, height); // Right side of the arrow
        break;
      case TooltipPosition.bottom:
        // Draw the tooltip with a bottom-pointing arrow
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), Radius.circular(borderRadius)));
        path.moveTo(width / 2 - 10, 0); // Left side of the arrow
        path.lineTo(width / 2, -10); // Arrow tip
        path.lineTo(width / 2 + 10, 0); // Right side of the arrow
        break;
      case TooltipPosition.left:
        // Draw the tooltip with a left-pointing arrow
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), Radius.circular(borderRadius)));
        path.moveTo(width, height / 2 - 10); // Top side of the arrow
        path.lineTo(width + 10, height / 2); // Arrow tip
        path.lineTo(width, height / 2 + 10); // Bottom side of the arrow
        break;
      case TooltipPosition.right:
        // Draw the tooltip with a right-pointing arrow
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), Radius.circular(borderRadius)));
        path.moveTo(0, height / 2 - 10); // Top side of the arrow
        path.lineTo(-10, height / 2); // Arrow tip
        path.lineTo(0, height / 2 + 10); // Bottom side of the arrow
        break;
    }

    // Draw the path (tooltip with border) onto the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No repaint needed since the tooltip remains static
  }
}
