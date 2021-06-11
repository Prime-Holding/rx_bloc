import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class LoginDependencies {
  LoginDependencies._(this.context);

  factory LoginDependencies.of(BuildContext context) =>
      _instance != null ? _instance! : _instance = LoginDependencies._(context);

  static LoginDependencies? _instance;

  final BuildContext context;

  /// List of all providers used throughout the app
  List<SingleChildWidget> get providers => [
    ..._blocs,
  ];

  List<Provider> get _blocs => [
    Provider(create: (_) => null),
  ];
}
