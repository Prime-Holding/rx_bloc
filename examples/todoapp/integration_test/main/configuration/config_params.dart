// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'build_app.dart';

class ConfigParams {
  const ConfigParams();

  ///General PatrolTesterConfig parameters
  static const generalExistsTimeout = Duration(seconds: 10);
  static const generalVisibleTimeout = Duration(seconds: 10);
  static const generalSettleTimeout = Duration(seconds: 10);
  static const settlePolicy = SettlePolicy.trySettle;

  ///General NativeAutomatorConfig parameters
  static const generalConnectionTimeout = Duration(seconds: 60);
  static const generalFindTimeout = Duration(seconds: 10);

  ///Specific widget-related PatrolTesterConfig parameters
  static const pageVisibleTimeout = Duration(seconds: 15);
}
