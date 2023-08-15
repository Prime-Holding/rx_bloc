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
  static List<RealtimeCommunicationType> supportedOptions = [
    RealtimeCommunicationType.none,
    RealtimeCommunicationType.sse,
  ];

  /// Parse enum from String
  static RealtimeCommunicationType parse(String value) {
    try {
      return RealtimeCommunicationType.supportedOptions
          .firstWhere((element) => element.name == value);
    } catch (_) {
      throw UnsupportedError('$value is not valid realtime communication type');
    }
  }

  @override
  String toString() => name;
}
