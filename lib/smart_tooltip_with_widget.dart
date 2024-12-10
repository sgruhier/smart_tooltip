import 'package:flutter/material.dart';
import 'package:smart_tooltip/smart_tooltip_text.dart';
import 'package:smart_tooltip/tooltip_with_widget_border.dart';

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

  /// Calculates the size of the tooltip by rendering it off-screen temporarily.
  /// Calls the provided [onComplete] callback once the size is calculated.
  void _calculateTooltipSize(VoidCallback onComplete) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Find the RenderBox of the tooltip using its global key
      final tooltipRenderBox =
          _tooltipKey.currentContext?.findRenderObject() as RenderBox?;

      // If the RenderBox exists, calculate the tooltip size
      if (tooltipRenderBox != null) {
        setState(() {
          tooltipWidth = tooltipRenderBox.size.width;
          tooltipHeight = tooltipRenderBox.size.height;
        });
        // Execute the callback after size calculation
        onComplete();
      }
    });
  }

  /// Displays the tooltip on the screen at the appropriate position.
  /// Handles tooltip positioning, size calculation, and ensures it does not overflow the screen.
  void _showTooltip() {
    // Prevent showing the tooltip again if it's already visible
    if (_isTooltipVisible) return;

    // Retrieve the RenderBox of the widget to which the tooltip is attached
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Retrieve the RenderBox of the overlay (to calculate global positions)
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    // Get the global position of the widget and its size
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final size = renderBox.size;

    // Get the screen dimensions
    final screenWidth = overlay.size.width;
    final screenHeight = overlay.size.height;

    // Temporarily insert a dummy tooltip off-screen to calculate its size
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: -9999, // Off-screen
        left: -9999,
        child: Material(
          color: Colors.transparent,
          child: Container(
            key: _tooltipKey, // Assign the tooltip key for size calculation
            child: widget.tooltipContent,
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);

    // Calculate tooltip size and determine its position
    _calculateTooltipSize(() {
      // Remove the dummy tooltip after size calculation
      _overlayEntry?.remove();

      // Initialize variables for tooltip position
      double top = 0.0;
      double left = 0.0;

      // Calculate available spaces around the widget
      final topSpace = offset.dy;
      final bottomSpace = screenHeight - (offset.dy + size.height);
      final leftSpace = offset.dx;
      final rightSpace = screenWidth - (offset.dx + size.width);
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
      // Clamp tooltip position to ensure it stays within the screen bounds
      top = top.clamp(0.0, screenHeight - tooltipHeight);
      left = left.clamp(0.0, screenWidth - tooltipWidth);

      // Insert the final tooltip into the overlay
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: top, // Final calculated top position
          left: left, // Final calculated left position
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: widget.borderColor, // Tooltip background color
                borderRadius: BorderRadius.circular(
                    widget.borderRadius), // Tooltip border radius
              ),
              width: tooltipWidth + 2, // Adjust width slightly for border
              height: tooltipHeight + 2, // Adjust height slightly for border
              child: Stack(
                children: [
                  // Custom painter for drawing the tooltip border
                  CustomPaint(
                    painter: TooltipWithWidgetBorder(
                      borderColor: widget.borderColor,
                      borderRadius: widget.borderRadius,
                      position: currentTooltipPosition,
                      width: tooltipWidth,
                      height: tooltipHeight,
                    ),
                  ),
                  // Tooltip content positioned slightly inside the border
                  Positioned(
                    top: 1, // Adjust for the border width
                    left: 1, // Adjust for the border width
                    child: Container(
                      child: widget.tooltipContent, // Tooltip content widget
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_overlayEntry!); // Insert the tooltip overlay
      _isTooltipVisible = true; // Mark the tooltip as visible
    });
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
