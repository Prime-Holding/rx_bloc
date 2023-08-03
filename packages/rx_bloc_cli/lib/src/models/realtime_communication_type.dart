part of '../commands/create_command.dart';

/// Available options for realtime communication
enum _RealtimeCommunicationType {
  none,
  sse,
  websocket,
  grpc;

  /// Options that are currently supported by RxBlocCLI
  static List<_RealtimeCommunicationType> supported = [
    _RealtimeCommunicationType.none,
    _RealtimeCommunicationType.sse,
  ];

  static _RealtimeCommunicationType parse(String value) =>
      _RealtimeCommunicationType.values.firstWhere(
        (element) => element.name == value,
      );

  @override
  String toString() => name;
}
