import 'package:flutter/material.dart';

class Scenario {
  /// Describe scenarios to be rendered by [DeviceBuilder]
  ///
  /// [name] - name of scenario in golden snapshot 'e.g 'error_state'
  ///
  /// [onCreate] (optional) - executes arbitrary behavior upon widget creation
  Scenario({
    required this.name,
    this.onCreate,
  });

  final String name;
  final Future<void> Function(Key)? onCreate;

  Scenario copyWith({
    String? name,
    Future<void> Function(Key)? onCreate,
  }) =>
      Scenario(
        name: name ?? this.name,
        onCreate: onCreate ?? this.onCreate,
      );
}
