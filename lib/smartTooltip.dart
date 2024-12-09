import 'package:flutter/material.dart';

import 'tooltipBorderPainter.dart';
import 'tooltipPainter.dart';

class SmartTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  final TextStyle textStyle;
  final TooltipPosition position;

  const SmartTooltip({
    super.key,
    required this.borderColor,
    required this.child,
    required this.message,
    this.borderWidth = 1.0,
    this.backgroundColor = Colors.black,
    this.textStyle = const TextStyle(
      color: Colors.white,
    ),
    this.position = TooltipPosition.top,
  });

  @override
  State<SmartTooltip> createState() => _SmartTooltipState();
}

enum TooltipPosition { top, bottom, left, right }

class _SmartTooltipState extends State<SmartTooltip> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isTooltipVisible = false;
  late TooltipPosition currentTooltipPosition;
  void _showTooltip() {
    if (_isTooltipVisible) return; // Prevent multiple insertions

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final size = renderBox.size;

    // Screen width for clamping
    final screenWidth = overlay.size.width;
    final screenHeight = overlay.size.height;

    // Dynamically calculate tooltip dimensions
    final textSpan = TextSpan(
      text: widget.message,
      style: widget.textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    // Layout the text with a constrained width (max 90% of screen width)
    final maxTooltipWidth = screenWidth * 0.90;
    textPainter.layout(maxWidth: maxTooltipWidth);

    final tooltipWidth = textPainter.size.width + 25.0; // Add padding
    final tooltipHeight = textPainter.size.height + 20.0;

    double top = 0.0;
    double left = 0.0;

    // Check available space in each direction
    double topSpace = offset.dy;
    double bottomSpace = screenHeight - (offset.dy + size.height);
    double leftSpace = offset.dx;
    double rightSpace = screenWidth - (offset.dx + size.width);

    // Tooltip shape logic based on position
    switch (widget.position) {
      case TooltipPosition.top:
        if (topSpace >= tooltipHeight &&
            tooltipWidth / 2 <= offset.dx &&
            offset.dx <= screenWidth - tooltipWidth / 2) {
          top = offset.dy - tooltipHeight - 13.0;
          left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
        } else {
          // Not enough space at top, check left or right
          if (leftSpace >= rightSpace) {
            // Place it to the left
            left = offset.dx - tooltipWidth - 13.0;
            top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
            currentTooltipPosition = TooltipPosition.left;
          } else {
            // Place it to the right
            left = offset.dx + size.width + 13.0;
            top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
            currentTooltipPosition = TooltipPosition.right;
          }
        }
        break;
      case TooltipPosition.bottom:
        if (bottomSpace >= tooltipHeight &&
            tooltipWidth / 2 <= offset.dx &&
            offset.dx <= screenWidth - tooltipWidth / 2) {
          top = offset.dy + size.height + 13.0;
          left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
        } else {
          if (topSpace >= tooltipHeight &&
              tooltipWidth / 2 <= offset.dx &&
              offset.dx <= screenWidth - tooltipWidth / 2) {
            top = offset.dy - tooltipHeight - 13.0;
            left = offset.dx + (size.width / 2) - (tooltipWidth / 2);

            currentTooltipPosition = TooltipPosition.top;
          } else {
            // Not enough space at bottom, check left or right
            if (leftSpace >= rightSpace) {
              // Place it to the left
              left = offset.dx - tooltipWidth - 13.0;
              top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
              currentTooltipPosition = TooltipPosition.left;
            } else {
              // Place it to the right
              left = offset.dx + size.width + 13.0;
              top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
              currentTooltipPosition = TooltipPosition.right;
            }
          }
        }
        break;
      case TooltipPosition.left:
        if (leftSpace >= tooltipWidth &&
            tooltipHeight / 2 <= bottomSpace &&
            tooltipHeight / 2 <= topSpace) {
          top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
          left = offset.dx - tooltipWidth - 13.0;
        } else {
          if (rightSpace >= tooltipWidth &&
              tooltipHeight / 2 <= bottomSpace &&
              tooltipHeight / 2 <= topSpace) {
            left = offset.dx + size.width + 13.0;
            top = offset.dy + (size.height / 2) - (tooltipHeight / 2);

            currentTooltipPosition = TooltipPosition.right;
          } else {
            // Not enough space at left, check top or bottom
            if (topSpace >= bottomSpace &&
                tooltipWidth / 2 <= offset.dx &&
                offset.dx <= screenWidth - tooltipWidth / 2) {
              // Place it above
              left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
              top = offset.dy - tooltipHeight - 13.0;
              currentTooltipPosition = TooltipPosition.top;
            } else {
              if (bottomSpace >= tooltipHeight &&
                  tooltipWidth / 2 <= offset.dx &&
                  offset.dx <= screenWidth - tooltipWidth / 2) {
                left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
                top = offset.dy + size.height + 13.0;
                currentTooltipPosition = TooltipPosition.bottom;
              } else {
                // Not enough space at bottom, check left or right
                if (leftSpace >= rightSpace) {
                  // Place it to the left
                  left = offset.dx - tooltipWidth - 13.0;
                  top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                  currentTooltipPosition = TooltipPosition.left;
                } else {
                  // Place it to the right
                  left = offset.dx + size.width + 13.0;
                  top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                  currentTooltipPosition = TooltipPosition.right;
                }
              }
            }
          }
        }
        break;
      case TooltipPosition.right:
        if (rightSpace >= tooltipWidth &&
            tooltipHeight / 2 <= bottomSpace &&
            tooltipHeight / 2 <= topSpace) {
          top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
          left = offset.dx + size.width + 13.0;
        } else {
          if (leftSpace >= tooltipWidth &&
              tooltipHeight / 2 <= bottomSpace &&
              tooltipHeight / 2 <= topSpace) {
            left = offset.dx - tooltipWidth - 13.0;
            top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
            currentTooltipPosition = TooltipPosition.left;
          } else {
            // Not enough space at right, check top or bottom
            if (topSpace >= bottomSpace &&
                tooltipWidth / 2 <= offset.dx &&
                offset.dx <= screenWidth - tooltipWidth / 2) {
              // Place it above
              left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
              top = offset.dy - tooltipHeight - 13.0;
              currentTooltipPosition = TooltipPosition.top;
            } else {
              // Place it below
              if (bottomSpace >= tooltipHeight &&
                  tooltipWidth / 2 <= offset.dx &&
                  offset.dx <= screenWidth - tooltipWidth / 2) {
                left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
                top = offset.dy + size.height + 13.0;
                currentTooltipPosition = TooltipPosition.bottom;
              } else {
                // Not enough space at bottom, check left or right
                if (leftSpace >= rightSpace) {
                  // Place it to the left
                  left = offset.dx - tooltipWidth - 13.0;
                  top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                  currentTooltipPosition = TooltipPosition.left;
                } else {
                  // Place it to the right
                  left = offset.dx + size.width + 13.0;
                  top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                  currentTooltipPosition = TooltipPosition.right;
                }
              }
            }
          }
        }
        break;
    }

    // Clamp to stay within screen bounds
    top = top.clamp(0.0, screenHeight - tooltipHeight);
    left = left.clamp(0.0, screenWidth - tooltipWidth);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: top,
        left: left,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            width: tooltipWidth,
            height: tooltipHeight,
            child: Stack(
              children: [
                CustomPaint(
                  painter: TooltipBorderPainter(
                    borderColor: widget.borderColor,
                    borderWidth: widget.borderWidth,
                    position: currentTooltipPosition,
                    width: tooltipWidth,
                    height: tooltipHeight,
                  ),
                ),
                Positioned(
                  top: widget.borderWidth,
                  left: widget.borderWidth,
                  child: CustomPaint(
                    painter: TooltipPainter(
                      message: widget.message,
                      backgroundColor: widget.backgroundColor,
                      textStyle: widget.textStyle,
                      position: currentTooltipPosition,
                      width: tooltipWidth - widget.borderWidth * 2,
                      height: tooltipHeight - widget.borderWidth * 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isTooltipVisible = true;
  }

  void hideTooltip() {
    if (!_isTooltipVisible) return; // Avoid removing a non-existent tooltip
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isTooltipVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    currentTooltipPosition = widget.position;
    return MouseRegion(
      key: _key,
      onEnter: (_) => _showTooltip(),
      onExit: (_) => hideTooltip(),
      child: widget.child,
    );
  }
}
