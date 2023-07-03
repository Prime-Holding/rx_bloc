{{> licence.dart }}

import 'build_app.dart';

class ConfigParams {
  const ConfigParams();

  ///General PatrolTesterConfig parameters
  static const generalExistsTimeout = Duration(seconds: 10);
  static const generalVisibleTimeout = Duration(seconds: 10);
  static const generalSettleTimeout = Duration(seconds: 10);
  static const settlePolicy = SettlePolicy.settle;

  ///General NativeAutomatorConfig parameters
  static const generalConnectionTimeout = Duration(seconds: 60);
  static const generalFindTimeout = Duration(seconds: 10);

  ///Specific widget-related PatrolTesterConfig parameters
  static const pageVisibleTimeout = Duration(seconds: 15);
}
