import 'package:flutter/material.dart';
import 'package:smart_tooltip/TooltipWithWidgetBorder.dart';
import 'package:smart_tooltip/smartTooltip.dart';

// changes
/// A widget that displays a customizable tooltip with a widget as its content.
/// The tooltip is dynamically positioned based on available space and user configuration.
class SmartTooltipWithWidget extends StatefulWidget {
  /// The widget over which the tooltip will be displayed.
  final Widget child;

  /// The widget content to be displayed inside the tooltip.
  final Widget tooltipContent;

  /// The color of the tooltip's border.
  final Color borderColor;

  /// The preferred position of the tooltip relative to the child widget.
  /// It can be `top`, `bottom`, `left`, or `right`.
  final TooltipPosition position;

  /// The border radius for the tooltip container.
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
  /// A global key to uniquely identify the widget for size and position calculations.
  final GlobalKey _key = GlobalKey();

  /// A key for the tooltip to measure its dimensions.
  final GlobalKey _tooltipKey = GlobalKey();

  /// An overlay entry to display the tooltip in the overlay stack.
  OverlayEntry? _overlayEntry;

  /// Tracks whether the tooltip is currently visible.
  bool _isTooltipVisible = false;

  /// Tracks the current position of the tooltip.
  late TooltipPosition currentTooltipPosition;

  /// Tracks the dynamically calculated width of the tooltip.
  double tooltipWidth = 0.0;

  /// Tracks the dynamically calculated height of the tooltip.
  double tooltipHeight = 0.0;

  // Additional methods, tooltip logic, and event handlers go here

  /// Calculates the size of the tooltip after the widget has been rendered.
  void _calculateTooltipSize() {
    // Adds a post-frame callback to ensure this code runs after the widget's layout phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Attempts to get the RenderBox of the tooltip widget to access its size.
      final tooltipRenderBox =
          _tooltipKey.currentContext?.findRenderObject() as RenderBox?;

      // If the RenderBox is found, updates the tooltip's width and height in the state.
      if (tooltipRenderBox != null) {
        setState(() {
          tooltipWidth = tooltipRenderBox.size.width;
          tooltipHeight = tooltipRenderBox.size.height;
        });
      }
    });
  }

  /// Shows the tooltip when triggered, determining its position based on available space on the screen.
  void _showTooltip() {
    // Return if the tooltip is already visible
    if (_isTooltipVisible) return;

    // Get the RenderBox for the widget that is being hovered on
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Get the Overlay for positioning the tooltip and calculate the offset of the widget
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final size = renderBox.size;

    // Get the screen size for clamping tooltip position within the visible screen area
    final screenWidth = overlay.size.width;
    final screenHeight = overlay.size.height;

    // Initialize variables for tooltip position
    double top = 0.0;
    double left = 0.0;

    // Calculate available space in different directions around the widget
    final topSpace = offset.dy; // Space available above the widget
    final bottomSpace =
        screenHeight - (offset.dy + size.height); // Space below the widget
    final leftSpace = offset.dx; // Space on the left of the widget
    final rightSpace = screenWidth -
        (offset.dx + size.width); // Space on the right of the widget

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

    // Clamp the calculated position to stay within the screen bounds
    top = top.clamp(0.0, screenHeight - tooltipHeight);
    left = left.clamp(0.0, screenWidth - tooltipWidth);

    // Create the OverlayEntry to display the tooltip in the overlay
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: top, // Positioning tooltip vertically
        left: left, // Positioning tooltip horizontally
        child: Material(
          color: Colors.transparent, // Tooltip background transparent
          child: Container(
            decoration: BoxDecoration(
              color: widget.borderColor, // Border color
              borderRadius:
                  BorderRadius.circular(widget.borderRadius), // Rounded corners
            ),
            width: tooltipWidth + 2, // Tooltip width with padding
            height: tooltipHeight + 2, // Tooltip height with padding
            child: Stack(
              children: [
                // Custom border for the tooltip
                CustomPaint(
                  painter: TooltipWithWidgetBorder(
                    borderColor: widget.borderColor,
                    borderRadius: widget.borderRadius,
                    position: currentTooltipPosition,
                    width: tooltipWidth + 2,
                    height: tooltipHeight + 2,
                  ),
                ),
                // Tooltip content inside the border
                Positioned(
                  top: 1, // Slight offset to make space for border
                  left: 1, // Slight offset to make space for border
                  child: Container(
                    key: _tooltipKey, // Key to access tooltip widget
                    decoration: BoxDecoration(
                      color: widget.borderColor, // Tooltip background color
                      borderRadius: BorderRadius.circular(
                          widget.borderRadius), // Rounded corners
                    ),
                    child: widget
                        .tooltipContent, // The content to be displayed inside the tooltip
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Insert the tooltip into the overlay
    Overlay.of(context).insert(_overlayEntry!);

    // Mark the tooltip as visible
    _isTooltipVisible = true;

    // Calculate the size of the tooltip after it is rendered
    _calculateTooltipSize();
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
