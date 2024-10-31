import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

class MockBiometricsAuthDataSource extends PinBiometricsAuthDataSource {
  MockBiometricsAuthDataSource({this.showBiometricsButton = false});

  final bool showBiometricsButton;

  @override
  Future<bool> get canCheckBiometrics async => showBiometricsButton;

  @override
  Future<bool> get isDeviceSupported async => showBiometricsButton;
}
