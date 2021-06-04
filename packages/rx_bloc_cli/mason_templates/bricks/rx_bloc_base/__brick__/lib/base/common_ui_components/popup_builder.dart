// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

/// PopupBuilder is a widget that enables displaying custom popup lists on
/// any specified widget. It is based on the PopupMenuButton widget
/// ( https://api.flutter.dev/flutter/material/PopupMenuButton-class.html ).
class PopupBuilder<T> extends StatelessWidget {
  const PopupBuilder({
    required this.items,
    this.child,
    this.highlightedValue,
    this.onSelected,
    this.onCanceled,
    this.tooltip = '',
    this.tooltipEnabled = false,
    Key? key,
  }) : super(key: key);

  /// List of [PopupMenuEntry] items that will be built.
  final List<PopupMenuEntry<T>> items;

  /// The [child] widget that once pressed will display the list of items.
  /// If no [child] widget specified, it will use the three dots icon instead.
  final Widget? child;

  /// The value of the item on the list that should be initially highlighted
  /// when the list is opened.
  final T? highlightedValue;

  /// Callback executed once any of the list items is selected.
  final Function(T?)? onSelected;

  /// Callback executed once the list has been dismissed without selection.
  final Function()? onCanceled;

  /// Tooltip shown when mouse hovered over [child] widget.
  final String tooltip;

  /// Flag indicating whether to show the tooltip or not.
  final bool tooltipEnabled;

  @override
  Widget build(BuildContext context) {
    final popupMenu = PopupMenuButton<T>(
      tooltip: tooltip,
      icon: child,
      initialValue: highlightedValue,
      itemBuilder: (context) => items,
      onSelected: (selected) => onSelected?.call(selected),
      onCanceled: () => onCanceled?.call(),
    );

    // Remove the splash effect and tooltip (if disabled)
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        tooltipTheme: !tooltipEnabled
            ? const TooltipThemeData(
                decoration: BoxDecoration(color: Colors.transparent),
              )
            : Theme.of(context).tooltipTheme,
      ),
      child: popupMenu,
    );
  }
}
