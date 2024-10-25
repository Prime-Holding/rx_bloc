// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'build_app.dart';
import 'config_params.dart';

class PatrolBaseConfig {
  /// The default values for PatrolTesterConfig fields are set at ConfigParams class.
  /// All these global values can be overridden at its Specific widget-related
  /// parameters section. More info -> at the class documentation.
  PatrolTesterConfig customPatrolTesterConfig() {
    PatrolTesterConfig patrolTesterConfig = const PatrolTesterConfig(
      existsTimeout: ConfigParams.generalExistsTimeout,
      visibleTimeout: ConfigParams.generalVisibleTimeout,
      settleTimeout: ConfigParams.generalSettleTimeout,
      settlePolicy: ConfigParams.settlePolicy,
    );
    return patrolTesterConfig;
  }

  /// Patrol NativeAutomatorConfig has far more options. Here only the most
  /// common ones are listed. More info -> at the class documentation.
  /// The default values are set at ConfigParams class.
  NativeAutomatorConfig customNativeAutomatorConfig() {
    NativeAutomatorConfig nativeAutomatorConfig = const NativeAutomatorConfig(
        connectionTimeout: ConfigParams.generalConnectionTimeout,
        findTimeout: ConfigParams.generalFindTimeout);
    return nativeAutomatorConfig;
  }

  void patrol(
    String description,
    Future<void> Function(PatrolIntegrationTester) callback, {
    bool? skip,
    dynamic tags,
  }) {
    // IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    patrolTest(
      description,
      callback,
      config: customPatrolTesterConfig(),
      nativeAutomatorConfig: customNativeAutomatorConfig(),
      skip: skip,
      tags: tags,
    );
  }
}
