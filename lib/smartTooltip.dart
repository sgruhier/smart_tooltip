import 'package:flutter/material.dart';
import 'package:smart_tooltip/TooltipBorderPainter.dart';
import 'package:smart_tooltip/TooltipPainter.dart';

/// A customizable widget for displaying tooltips.
///
/// [SmartTooltip] allows you to show a tooltip when hovering over or tapping a child widget.
/// You can customize the message, tooltip position, background color, border, and text style.
class SmartTooltip extends StatefulWidget {
  /// The widget that triggers the tooltip.
  final Widget child;

  /// The message to display in the tooltip.
  final String message;

  /// The background color of the tooltip.
  /// Defaults to [Colors.black].
  final Color backgroundColor;

  /// The border color of the tooltip.
  final Color borderColor;

  /// The width of the border surrounding the tooltip.
  /// Defaults to `1.0`.
  final double borderWidth;

  /// The text style of the tooltip message.
  /// Defaults to white text.
  final TextStyle textStyle;

  /// The position of the tooltip relative to the child widget.
  ///
  /// Can be one of the following:
  /// - [TooltipPosition.top]: Displays the tooltip above the child widget.
  /// - [TooltipPosition.bottom]: Displays the tooltip below the child widget.
  /// - [TooltipPosition.left]: Displays the tooltip to the left of the child widget.
  /// - [TooltipPosition.right]: Displays the tooltip to the right of the child widget.
  /// Defaults to [TooltipPosition.top].
  final TooltipPosition position;

  /// Creates a new instance of [SmartTooltip].
  ///
  /// - [child]: The widget that triggers the tooltip (required).
  /// - [message]: The tooltip message to display (required).
  /// - [borderColor]: The color of the tooltip border (required).
  ///
  /// Example usage:
  /// ```dart
  /// SmartTooltip(
  ///   message: "This is a tooltip!",
  ///   borderColor: Colors.blue,
  ///   child: Icon(Icons.info),
  /// );
  /// ```
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

/// Specifies the position of the tooltip relative to the child widget.
enum TooltipPosition {
  /// Tooltip appears above the child widget.
  top,

  /// Tooltip appears below the child widget.
  bottom,

  /// Tooltip appears to the left of the child widget.
  left,

  /// Tooltip appears to the right of the child widget.
  right
}

class _SmartTooltipState extends State<SmartTooltip> {
  /// A key to uniquely identify the child widget and calculate its position on the screen.
  final GlobalKey _key = GlobalKey();

  /// The overlay entry used to display the tooltip above other widgets.
  OverlayEntry? _overlayEntry;

  /// Tracks whether the tooltip is currently visible.
  bool _isTooltipVisible = false;

  /// The current position of the tooltip, updated dynamically.
  late TooltipPosition currentTooltipPosition;

  // Additional functionality would go here (e.g., methods to show or hide the tooltip).

  /// Displays the tooltip above the overlay.
  ///
  /// This method calculates the position and size of the tooltip relative to the child widget.
  /// It ensures the tooltip is dynamically placed within screen boundaries and adjusts its
  /// position based on available space.
  void _showTooltip() {
    // Check if the tooltip is already visible to prevent multiple insertions.
    if (_isTooltipVisible) return;

    // Get the render box of the child widget.
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Get the render box of the overlay to calculate global positions.
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    // Calculate the global offset of the child widget relative to the overlay.
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

    // Get the size of the child widget.
    final size = renderBox.size;

    // Retrieve the screen dimensions from the overlay.
    final screenWidth = overlay.size.width;
    final screenHeight = overlay.size.height;

    // Prepare the tooltip text for rendering.
    final textSpan = TextSpan(
      text: widget.message, // Tooltip message provided by the user.
      style: widget.textStyle, // Text style defined by the user.
    );

    // Use TextPainter to measure and layout the text.
    final textPainter = TextPainter(
      text: textSpan,
      textDirection:
          TextDirection.ltr, // Default to left-to-right text direction.
    );

    // Constrain the text layout to a maximum of 90% of the screen width.
    final maxTooltipWidth = screenWidth * 0.90;
    textPainter.layout(maxWidth: maxTooltipWidth);

    // Add padding to the tooltip dimensions.
    final tooltipWidth =
        textPainter.size.width + 25.0; // 25.0 for horizontal padding.
    final tooltipHeight =
        textPainter.size.height + 20.0; // 20.0 for vertical padding.

    // Initialize tooltip position variables.
    double top = 0.0;
    double left = 0.0;

    // Calculate available space in each direction.
    double topSpace = offset.dy; // Space above the child widget.
    double bottomSpace =
        screenHeight - (offset.dy + size.height); // Space below.
    double leftSpace = offset.dx; // Space to the left of the child widget.
    double rightSpace =
        screenWidth - (offset.dx + size.width); // Space to the right.

    // Logic to determine the best position and adjust placement would follow here.

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
// Ensures the tooltip's position stays within the visible screen area.
    top = top.clamp(0.0, screenHeight - tooltipHeight);
    left = left.clamp(0.0, screenWidth - tooltipWidth);

// Create an OverlayEntry to render the tooltip above other UI elements
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: top, // Tooltip's vertical position
        left: left, // Tooltip's horizontal position
        child: Material(
          color: Colors.transparent, // Keeps the tooltip background transparent
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor, // Tooltip background color
              borderRadius: BorderRadius.circular(5.0), // Rounded corners
            ),
            width: tooltipWidth, // Width of the tooltip based on text
            height: tooltipHeight, // Height of the tooltip based on text
            child: Stack(
              children: [
                // Custom painter for the tooltip border
                CustomPaint(
                  painter: TooltipBorderPainter(
                    borderColor: widget.borderColor, // Tooltip border color
                    borderWidth: widget.borderWidth, // Tooltip border width
                    position: currentTooltipPosition, // Tooltip position
                    width: tooltipWidth, // Tooltip width
                    height: tooltipHeight, // Tooltip height
                  ),
                ),
                // Positioned painter for the tooltip text
                Positioned(
                  top: widget.borderWidth, // Adjusted to leave space for border
                  left:
                      widget.borderWidth, // Adjusted to leave space for border
                  child: CustomPaint(
                    painter: TooltipPainter(
                      message: widget.message, // Text displayed in the tooltip
                      backgroundColor:
                          widget.backgroundColor, // Tooltip background
                      textStyle: widget.textStyle, // Text style
                      position: currentTooltipPosition, // Tooltip position
                      width:
                          tooltipWidth - widget.borderWidth * 2, // Text width
                      height:
                          tooltipHeight - widget.borderWidth * 2, // Text height
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

// Insert the OverlayEntry into the Overlay stack to render the tooltip
    Overlay.of(context).insert(_overlayEntry!);

// Update the state to indicate the tooltip is visible
    _isTooltipVisible = true;
  }

  /// Hides the tooltip by removing the `OverlayEntry` from the overlay stack.
  void hideTooltip() {
    if (!_isTooltipVisible) return; // Avoid removing a non-existent tooltip

    // Remove the tooltip overlay entry
    _overlayEntry?.remove();
    _overlayEntry = null;

    // Update the state to indicate the tooltip is no longer visible
    _isTooltipVisible = false;
  }

  /// Builds the widget and manages tooltip visibility using mouse events.
  @override
  Widget build(BuildContext context) {
    // Set the initial tooltip position as provided in the widget
    currentTooltipPosition = widget.position;

    return MouseRegion(
      key: _key, // Key to uniquely identify this widget for layout purposes

      // Trigger to show the tooltip when the mouse enters the region
      onEnter: (_) => _showTooltip(),

      // Trigger to hide the tooltip when the mouse exits the region
      onExit: (_) => hideTooltip(),

      // The child widget over which the tooltip is displayed
      child: widget.child,
    );
  }
}
