import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// [RxUnfocuser] handles dismiss keyboard on tap
///
/// Dismisses keyboard on tap within the area of the [child] Widget,
///
/// It does NOT dismiss the current focus in the following cases:
///  * the tap occurs within the area of a descendant which is is editable
///
///  * the tap occurs within the area of a descendant which contains text
///
/// If the tap occurs within the area of a descendant which is specifically
/// wrapped in [RxIgnoreUnfocuser] a dismiss wouldn't happen
///
/// If the tap occurs within the area of a descendant which is wrapped with
/// a [RxForceUnfocuser] the keyboard will be dismissed even if it occurs
/// within the area of a descendant which is editable or text
///
/// [RxIgnoreUnfocuser] takes precedence over [RxForceUnfocuser] despite
/// their order in the widget tree
///
/// See Also:
///
///  * [RxIgnoreUnfocuser] - used to ignore keyboard dismiss within a given area
///
///  * [RxForceUnfocuser] - used to force keyboard dismiss within an area
///
///  * [RenderEditable] - the renderer for an editable text field.
///
///  * [RenderParagraph] - A render object that displays a paragraph of text.
class RxUnfocuser extends StatefulWidget {
  ///Default constructor
  const RxUnfocuser({Key? key, this.child}) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// The hit test area depends on the size of this widget
  final Widget? child;

  @override
  _RxUnfocuserState createState() => _RxUnfocuserState();
}

class _RxUnfocuserState extends State<RxUnfocuser> {
  RenderBox? _lastRenderBox;

  @override
  Widget build(BuildContext context) => Listener(
        onPointerUp: (e) {
          final rb = context.findRenderObject() as RenderBox;
          final result = BoxHitTestResult();
          rb.hitTest(result, position: e.position);

          if (result.path.any((entry) =>
              entry.target.runtimeType == RxIgnoreUnfocuserRenderBox)) {
            return;
          }
          final isEditable = result.path.any((entry) =>
              entry.target.runtimeType == RenderEditable ||
              entry.target.runtimeType == RenderParagraph ||
              entry.target.runtimeType == RxForceUnfocuserRenderBox);

          final currentFocus = FocusScope.of(context);
          if (!isEditable) {
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
              _lastRenderBox = null;
            }
          } else {
            for (final entry in result.path) {
              final isEditable = entry.target.runtimeType == RenderEditable ||
                  entry.target.runtimeType == RenderParagraph ||
                  entry.target.runtimeType == RxForceUnfocuserRenderBox;

              if (isEditable) {
                final renderBox = (entry.target as RenderBox);
                if (_lastRenderBox != renderBox) {
                  _lastRenderBox = renderBox;
                  setState(() {});
                }
              }
            }
          }
        },
        child: widget.child,
      );
}

//TODO fix RxIgnoreUnfocuser
/// [RxIgnoreUnfocuser] is used to ignore keyboard dismiss within a given area
///
/// If a tap occurs within the area of a descendant to [RxUnfocuser],
/// which is specifically wrapped in [RxIgnoreUnfocuser]
/// a dismiss wouldn't happen
///
/// [RxIgnoreUnfocuser] takes precedence over [RxForceUnfocuser] despite
/// their order in the widget tree
///
/// See Also:
///
///  * [RxUnfocuser] - used to ignore keyboard dismiss within a given area
///
///  * [RxForceUnfocuser] - used to force keyboard dismiss within an area
class RxIgnoreUnfocuser extends SingleChildRenderObjectWidget {
  ///Default Constructor
  const RxIgnoreUnfocuser({
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  RxIgnoreUnfocuserRenderBox createRenderObject(BuildContext context) =>
      RxIgnoreUnfocuserRenderBox();
}

//TODO fix RxForceUnfocuser
/// [RxForceUnfocuser] forces dismiss keyboard on tap
///
/// If the tap occurs within the area of a descendant to [RxUnfocuser],
/// which is wrapped with a [RxForceUnfocuser] the keyboard will be dismissed
/// even if it occurs within the area of a descendant which is editable or text.
///
/// [RxIgnoreUnfocuser] takes precedence over [RxForceUnfocuser] despite
/// their order in the widget tree.
///
/// See Also:
///
///  * [RxIgnoreUnfocuser] - used to ignore keyboard dismiss
///                          within a given area.
///
///  * [RxUnfocuser] - used to force keyboard dismiss within an area.
class RxForceUnfocuser extends SingleChildRenderObjectWidget {
  ///Default Constructor
  const RxForceUnfocuser({
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  RxForceUnfocuserRenderBox createRenderObject(BuildContext context) =>
      RxForceUnfocuserRenderBox();
}

///The render box for [RxIgnoreUnfocuser]
///
/// See Also:
///   * [RenderPointerListener]
class RxIgnoreUnfocuserRenderBox extends RenderPointerListener {}

///The render box for [RxForceUnfocuser]
///
/// See Also:
///   * [RenderPointerListener]
class RxForceUnfocuserRenderBox extends RenderPointerListener {}
