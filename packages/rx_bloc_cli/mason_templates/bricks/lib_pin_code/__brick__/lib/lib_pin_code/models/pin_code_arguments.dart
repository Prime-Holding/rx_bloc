{{> licence.dart }}

class PinCodeArguments {
  const PinCodeArguments({
    required this.title,
    this.isSessionTimeout = false,
    this.onReturn,
  });

  final String title;
  final bool isSessionTimeout;
  final Function? onReturn;
}