/// Available options for CI/CD
enum CICDType {
  /// None
  none,

  /// Fastlane
  fastlane;

  /// Options that are currently supported by RxBlocCLI
  static List<CICDType> supportedOptions = [
    CICDType.none,
    CICDType.fastlane,
  ];

  /// Parse enum from String
  static CICDType parse(String value) {
    try {
      return CICDType.supportedOptions
          .firstWhere((element) => element.name == value);
    } catch (_) {
      throw UnsupportedError('$value is not valid ci/cd option');
    }
  }

  @override
  String toString() => name;
}
