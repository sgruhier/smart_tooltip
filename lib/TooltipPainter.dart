import 'package:flutter/material.dart';

import 'smartTooltip.dart';

/// A custom painter for drawing the tooltip background and text based on position.
class TooltipPainter extends CustomPainter {
  final String message; // The text message to display in the tooltip
  final Color backgroundColor; // Background color of the tooltip
  final TextStyle textStyle; // Style for the text displayed inside the tooltip
  final TooltipPosition
      position; // Position of the tooltip (top, bottom, left, or right)
  final double width; // Width of the tooltip
  final double height; // Height of the tooltip

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
    // Set up the paint object for the tooltip background
    final Paint paint = Paint()
      ..color = backgroundColor // Set the background color
      ..style = PaintingStyle.fill; // Make the background filled

    final Path path = Path();

    // Tooltip shape drawing logic based on the position
    switch (position) {
      case TooltipPosition.top:
        // Draw the rounded rectangle and arrow pointing downwards
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(width / 2 - 10, height); // Arrow left side
        path.lineTo(width / 2, height + 10); // Arrow tip
        path.lineTo(width / 2 + 10, height); // Arrow right side
        break;
      case TooltipPosition.bottom:
        // Draw the rounded rectangle and arrow pointing upwards
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(width / 2 - 10, 0); // Arrow left side
        path.lineTo(width / 2, -10); // Arrow tip
        path.lineTo(width / 2 + 10, 0); // Arrow right side
        break;
      case TooltipPosition.left:
        // Draw the rounded rectangle and arrow pointing right
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(width, height / 2 - 10); // Arrow top side
        path.lineTo(width + 10, height / 2); // Arrow tip
        path.lineTo(width, height / 2 + 10); // Arrow bottom side
        break;
      case TooltipPosition.right:
        // Draw the rounded rectangle and arrow pointing left
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, width, height), const Radius.circular(5)));
        path.moveTo(0, height / 2 - 10); // Arrow top side
        path.lineTo(-10, height / 2); // Arrow tip
        path.lineTo(0, height / 2 + 10); // Arrow bottom side
        break;
    }

    // Draw the tooltip shape on the canvas
    canvas.drawPath(path, paint);

    // Draw the tooltip text
    final TextSpan span = TextSpan(
      text: message,
      style: textStyle,
    );

    final TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr, // Set the text direction
      maxLines: 2, // Limit to two lines if the text is too long
    );
    textPainter.layout(maxWidth: width - 10); // Add padding to the text

    // Paint the text on the canvas at the appropriate position
    textPainter.paint(canvas, Offset(10, (height - textPainter.height) / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // No need to repaint since the tooltip does not change dynamically
    return false;
  }
}
