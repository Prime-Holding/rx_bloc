import 'build_app.dart';
import 'config_params.dart';

class PatrolBaseConfig {
  // The commented code below is intended for future implementation related to
  // building and testing of different flavors
  /*
  late List<String> _args;

  ConfigTest(List<String> args){
      _args = args;
  }

  String _getPackageName() {
      EnvSet env = EnvSet(_args);
      return env.parseFlavor();
  }
*/

  // The default values for PatrolTesterConfig fields are set at ConfigParams class.
  // All these global values can be overridden at its Specific widget-related
  // parameters section. More info -> at the class documentation.
  PatrolTesterConfig customPatrolTesterConfig() {
    PatrolTesterConfig patrolTesterConfig = const PatrolTesterConfig(
        existsTimeout: ConfigParams.generalExistsTimeout,
        visibleTimeout: ConfigParams.generalVisibleTimeout,
        settleTimeout: ConfigParams.generalSettleTimeout,
        settlePolicy: ConfigParams.generalSettlePolicy);
    return patrolTesterConfig;
  }

  // Patrol NativeAutomatorConfig has far more options. Here only the most
  // common ones are listed. More info -> at the class documentation.
  // The default values are set at ConfigParams class.
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
  }) {
    patrolTest(
      description,
      callback,
      config: customPatrolTesterConfig(),
      nativeAutomatorConfig: customNativeAutomatorConfig(),
      skip: skip,
    );
  }
}
