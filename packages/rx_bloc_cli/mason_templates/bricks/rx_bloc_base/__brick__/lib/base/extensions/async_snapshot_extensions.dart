import 'package:flutter/material.dart';

extension AsyncSnapshotLoadingState on AsyncSnapshot<bool> {
  /// The loading state extracted from the snapshot
  bool get isLoading => hasData && data!;

  /// The color based on the isLoading state
  Color get buttonColor => isLoading ? Colors.blueGrey : Colors.blue;
}
