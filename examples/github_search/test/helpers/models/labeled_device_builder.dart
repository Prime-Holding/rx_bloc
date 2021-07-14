import 'package:golden_toolkit/golden_toolkit.dart';

class LabeledDeviceBuilder extends DeviceBuilder {
  LabeledDeviceBuilder({
    required this.label,
  }) : super();

  final String label;

  @override
  String toString() => label;
}
