// Source: https://github.com/greendrop/flutter_news_sample/blob/develop/test/support/alchemist/device.dart

import 'package:flutter/material.dart';

/// Configuration class used for setting up golden tests
class Device {
  /// This [Device] is a configuration for golden test
  const Device({
    required this.size,
    required this.name,
    this.devicePixelRatio = 1.0,
    this.textScaleFactor = 1.0,
    this.brightness = Brightness.light,
    this.safeArea = EdgeInsets.zero,
  });

  /// Example of phone with smallest phone screens
  static const Device phone = Device(name: 'phone', size: Size(375, 667));

  /// Example of phone that matches specs of iphone11
  static const Device iphone11 = Device(
    name: 'iphone11',
    size: Size(414, 896),
    devicePixelRatio: 1.0,
    safeArea: EdgeInsets.only(top: 44, bottom: 34),
  );

  /// [tabletPortrait] example of tablet that in portrait mode
  static const Device tabletPortrait =
      Device(name: 'tablet_portrait', size: Size(1024, 1366));

  /// [tabletLandscape] example of tablet that in landscape mode
  static const Device tabletLandscape =
      Device(name: 'tablet_landscape', size: Size(1366, 1024));

  static List<Device> all = [
    phone,
    phone.dark(),
    phone.toLandscape(),
    phone.toLandscape().dark(),
    tabletPortrait,
    tabletPortrait.dark(),
    tabletLandscape,
    tabletLandscape.dark(),
  ];

  /// The [name] of the device. Ex: Phone, Tablet, Watch
  final String name;

  /// The screen [size] of the device. Ex: Size(1366, 1024))
  final Size size;

  /// Device Pixel Ratio
  final double devicePixelRatio;

  /// Custom text scale factor
  final double textScaleFactor;

  /// Platform brightness (light or dark mode)
  final Brightness brightness;

  /// Insets to define a safe area
  final EdgeInsets safeArea;

  /// Convenience function for [Device] modification
  Device copyWith({
    Size? size,
    double? devicePixelRatio,
    String? name,
    double? textScale,
    Brightness? brightness,
    EdgeInsets? safeArea,
  }) {
    return Device(
      size: size ?? this.size,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      name: name ?? this.name,
      textScaleFactor: textScale ?? textScaleFactor,
      brightness: brightness ?? this.brightness,
      safeArea: safeArea ?? this.safeArea,
    );
  }

  /// Convenience method to copy the current device and apply dark theme
  Device dark() {
    return Device(
      size: size,
      devicePixelRatio: devicePixelRatio,
      textScaleFactor: textScaleFactor,
      brightness: Brightness.dark,
      safeArea: safeArea,
      name: '${name}_dark',
    );
  }

  /// Convenience method to transform the current device to a landscape version
  Device toLandscape() {
    return copyWith(size: Size(size.height, size.width));
  }

  @override
  String toString() {
    return 'Device: $name, '
        '${size.width}x${size.height} @ $devicePixelRatio, '
        'text: $textScaleFactor, $brightness, safe: $safeArea';
  }

  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;
  bool get isPortrait => size.height > size.width;
  bool get isLandscape => size.width > size.height;
  bool get isTablet => size.shortestSide > 600;
  bool get isPhone => size.shortestSide <= 600;
}
