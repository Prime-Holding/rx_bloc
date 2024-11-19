part of '../rx_bloc_generator.dart';

/// Validates the main bloc file and provides the generator the needed data
class _BuildCoordinatorController {
  _BuildCoordinatorController({
    required this.data,
  });

  final String data;

  String generate() {
    return data;
  }
}
