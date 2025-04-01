{{> licence.dart }}

class PinCodeArguments {
  const PinCodeArguments({
    required this.title,
    this.onReturn,
    this.showBiometricsButton = false,
    this.updateToken,
  });

  final String title;
  final Function? onReturn;
  final bool showBiometricsButton;
  final String? updateToken;
}
