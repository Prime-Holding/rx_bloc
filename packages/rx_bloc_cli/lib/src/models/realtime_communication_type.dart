/// Available options for realtime communication
enum RealtimeCommunicationType {
  /// None
  none,

  /// SSE
  sse,

  /// Websocket
  websocket,

  /// GRPC
  grpc;

  /// Options that are currently supported by RxBlocCLI
  static List<RealtimeCommunicationType> supported = [
    RealtimeCommunicationType.none,
    RealtimeCommunicationType.sse,
  ];

  /// Parse enum from String
  static RealtimeCommunicationType parse(String value) =>
      RealtimeCommunicationType.values.firstWhere(
        (element) => element.name == value,
      );

  @override
  String toString() => name;
}
