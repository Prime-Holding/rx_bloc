import 'package:flutter/material.dart';

/// Enum to specify the alignment of the scenario within the resulting layout
enum GoldenAlignment {
  top,
  center,
  bottom;

  /// Converts the [GoldenAlignment] to a [TableCellVerticalAlignment]
  TableCellVerticalAlignment asCellAlignment() {
    switch (this) {
      case GoldenAlignment.top:
        return TableCellVerticalAlignment.top;
      case GoldenAlignment.center:
        return TableCellVerticalAlignment.middle;
      case GoldenAlignment.bottom:
        return TableCellVerticalAlignment.bottom;
    }
  }
}
