import 'package:flutter/material.dart';
import 'package:smart_tooltip/smartTooltip.dart';

// changes
/// Custom painter to draw the border for the tooltip based on its position.
class TooltipBorderPainter extends CustomPainter {
  final Color borderColor; // Color of the border
  final double borderWidth; // Width of the border
  final TooltipPosition
      position; // Position of the tooltip (top, bottom, left, or right)
  final double width; // Width of the tooltip
  final double height; // Height of the tooltip

  // Constructor to initialize the values
  TooltipBorderPainter({
    required this.borderColor,
    this.borderWidth = 2.0,
    required this.position,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create a Paint object to style the border
    final Paint paint = Paint()
      ..color = borderColor // Set border color
      ..style = PaintingStyle.stroke // Make sure it's a border (not filled)
      ..strokeWidth = borderWidth; // Set the border width

    // Create a path to define the border shape
    final Path path = Path();

    // Tooltip border drawing logic based on position
    switch (position) {
      case TooltipPosition.top:
        // Draw rounded rectangle for the tooltip and the arrow pointing downwards
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(width / 2 - 10, height); // Move to the tip of the arrow
        path.lineTo(width / 2, height + 10); // Draw the left side of the arrow
        path.lineTo(width / 2 + 10, height); // Draw the right side of the arrow
        break;
      case TooltipPosition.bottom:
        // Draw rounded rectangle for the tooltip and the arrow pointing upwards
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(width / 2 - 10, 0); // Move to the tip of the arrow
        path.lineTo(width / 2, -10); // Draw the left side of the arrow
        path.lineTo(width / 2 + 10, 0); // Draw the right side of the arrow
        break;
      case TooltipPosition.left:
        // Draw rounded rectangle for the tooltip and the arrow pointing right
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(width, height / 2 - 10); // Move to the tip of the arrow
        path.lineTo(width + 10, height / 2); // Draw the top side of the arrow
        path.lineTo(
            width, height / 2 + 10); // Draw the bottom side of the arrow
        break;
      case TooltipPosition.right:
        // Draw rounded rectangle for the tooltip and the arrow pointing left
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(0, height / 2 - 10); // Move to the tip of the arrow
        path.lineTo(-10, height / 2); // Draw the top side of the arrow
        path.lineTo(0, height / 2 + 10); // Draw the bottom side of the arrow
        break;
    }

    // Draw the path on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // No need to repaint, the border is static
    return false;
  }
}
