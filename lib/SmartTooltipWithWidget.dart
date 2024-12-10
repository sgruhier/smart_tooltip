import 'package:flutter/material.dart';

import 'TooltipWithWidgetBorder.dart';
import 'smartTooltip.dart';

class SmartTooltipWithWidget extends StatefulWidget {
  final Widget child;
  final Widget tooltipContent;
  final Color borderColor;
  final TooltipPosition position;
  final double borderRadius;

  const SmartTooltipWithWidget({
    super.key,
    required this.borderRadius,
    required this.child,
    required this.tooltipContent,
    this.borderColor = Colors.black,
    this.position = TooltipPosition.top,
  });

  @override
  State<SmartTooltipWithWidget> createState() => _SmartTooltipWithWidgetState();
}

class _SmartTooltipWithWidgetState extends State<SmartTooltipWithWidget> {
  final GlobalKey _key = GlobalKey();
  final GlobalKey _tooltipKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isTooltipVisible = false;
  late TooltipPosition currentTooltipPosition;

  double tooltipWidth = 0.0;
  double tooltipHeight = 0.0;

  void _calculateTooltipSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tooltipRenderBox =
          _tooltipKey.currentContext?.findRenderObject() as RenderBox?;
      if (tooltipRenderBox != null) {
        setState(() {
          tooltipWidth = tooltipRenderBox.size.width;
          tooltipHeight = tooltipRenderBox.size.height;
        });
      }
    });
  }

  void _showTooltip() {
    if (_isTooltipVisible) return;

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final size = renderBox.size;
    final screenWidth = overlay.size.width;
    final screenHeight = overlay.size.height;

    double top = 0.0;
    double left = 0.0;

    // Determine available spaces
    final topSpace = offset.dy;
    final bottomSpace = screenHeight - (offset.dy + size.height);
    final leftSpace = offset.dx;
    final rightSpace = screenWidth - (offset.dx + size.width);

    // Tooltip shape logic based on position
    switch (widget.position) {
      case TooltipPosition.top:
        if (topSpace >= tooltipHeight &&
            tooltipWidth / 2 <= offset.dx &&
            offset.dx <= screenWidth - tooltipWidth / 2) {
          top = offset.dy - tooltipHeight - 20;
          left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
        } else {
          // Not enough space at top, check left or right
          if (leftSpace >= rightSpace) {
            // Place it to the left
            left = offset.dx - tooltipWidth - 20;
            top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
            currentTooltipPosition = TooltipPosition.left;
          } else {
            // Place it to the right
            left = offset.dx + size.width + 20;
            top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
            currentTooltipPosition = TooltipPosition.right;
          }
        }
        break;
      case TooltipPosition.bottom:
        if (bottomSpace >= tooltipHeight &&
            tooltipWidth / 2 <= offset.dx &&
            offset.dx <= screenWidth - tooltipWidth / 2) {
          top = offset.dy + size.height + 20;
          left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
        } else {
          if (topSpace >= tooltipHeight &&
              tooltipWidth / 2 <= offset.dx &&
              offset.dx <= screenWidth - tooltipWidth / 2) {
            top = offset.dy - tooltipHeight - 20;
            left = offset.dx + (size.width / 2) - (tooltipWidth / 2);

            currentTooltipPosition = TooltipPosition.top;
          } else {
            // Not enough space at bottom, check left or right
            if (leftSpace >= rightSpace) {
              // Place it to the left
              left = offset.dx - tooltipWidth - 20;
              top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
              currentTooltipPosition = TooltipPosition.left;
            } else {
              // Place it to the right
              left = offset.dx + size.width + 20;
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
          left = offset.dx - tooltipWidth - 20;
        } else {
          if (rightSpace >= tooltipWidth &&
              tooltipHeight / 2 <= bottomSpace &&
              tooltipHeight / 2 <= topSpace) {
            left = offset.dx + size.width + 20;
            top = offset.dy + (size.height / 2) - (tooltipHeight / 2);

            currentTooltipPosition = TooltipPosition.right;
          } else {
            // Not enough space at left, check top or bottom
            if (topSpace >= bottomSpace &&
                tooltipWidth / 2 <= offset.dx &&
                offset.dx <= screenWidth - tooltipWidth / 2) {
              // Place it above
              left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
              top = offset.dy - tooltipHeight - 20;
              currentTooltipPosition = TooltipPosition.top;
            } else {
              if (bottomSpace >= tooltipHeight &&
                  tooltipWidth / 2 <= offset.dx &&
                  offset.dx <= screenWidth - tooltipWidth / 2) {
                left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
                top = offset.dy + size.height + 20;
                currentTooltipPosition = TooltipPosition.bottom;
              } else {
                // Not enough space at bottom, check left or right
                if (leftSpace >= rightSpace) {
                  // Place it to the left
                  left = offset.dx - tooltipWidth - 20;
                  top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                  currentTooltipPosition = TooltipPosition.left;
                } else {
                  // Place it to the right
                  left = offset.dx + size.width + 20;
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
          left = offset.dx + size.width + 20;
        } else {
          if (leftSpace >= tooltipWidth &&
              tooltipHeight / 2 <= bottomSpace &&
              tooltipHeight / 2 <= topSpace) {
            left = offset.dx - tooltipWidth - 20;
            top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
            currentTooltipPosition = TooltipPosition.left;
          } else {
            // Not enough space at right, check top or bottom
            if (topSpace >= bottomSpace &&
                tooltipWidth / 2 <= offset.dx &&
                offset.dx <= screenWidth - tooltipWidth / 2) {
              // Place it above
              left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
              top = offset.dy - tooltipHeight - 20;
              currentTooltipPosition = TooltipPosition.top;
            } else {
              // Place it below
              if (bottomSpace >= tooltipHeight &&
                  tooltipWidth / 2 <= offset.dx &&
                  offset.dx <= screenWidth - tooltipWidth / 2) {
                left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
                top = offset.dy + size.height + 20;
                currentTooltipPosition = TooltipPosition.bottom;
              } else {
                // Not enough space at bottom, check left or right
                if (leftSpace >= rightSpace) {
                  // Place it to the left
                  left = offset.dx - tooltipWidth - 20;
                  top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                  currentTooltipPosition = TooltipPosition.left;
                } else {
                  // Place it to the right
                  left = offset.dx + size.width + 20;
                  top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                  currentTooltipPosition = TooltipPosition.right;
                }
              }
            }
          }
        }
        break;
    }

    // Clamp values to avoid overflowing
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
              color: widget.borderColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            width: tooltipWidth + 2,
            height: tooltipHeight + 2,
            child: Stack(
              children: [
                CustomPaint(
                  painter: TooltipWithWidgetBorder(
                    borderColor: widget.borderColor,
                    borderRadius: widget.borderRadius,
                    position: currentTooltipPosition,
                    width: tooltipWidth + 2,
                    height: tooltipHeight + 2,
                  ),
                ),
                Positioned(
                  top: 1,
                  left: 1,
                  child: Container(
                    key: _tooltipKey,
                    decoration: BoxDecoration(
                      color: widget.borderColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: widget.tooltipContent,
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

    // Calculate size after rendering
    _calculateTooltipSize();
  }

  void hideTooltip() {
    if (!_isTooltipVisible) return;
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
