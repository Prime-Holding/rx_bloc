{{> licence.dart }}

class PinCodeArguments {
  const PinCodeArguments({
    required this.title,
    this.isSessionTimeout = false,
    this.onReturn,
    this.showBiometricsButton = false,
  });

  final String title;
  final bool isSessionTimeout;
  final Function? onReturn;
  final bool showBiometricsButton;
}