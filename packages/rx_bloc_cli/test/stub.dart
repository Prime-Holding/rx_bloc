import 'package:rx_bloc_cli/src/models/command_arguments.dart';

final class Stub {
  Stub._();

  static Map<String, Object> get defaultValues {
    var map = <String, Object>{
      CommandArguments.projectName.name: 'testapp',
    };

    for (final argument in CommandArguments.values) {
      if (!argument.mandatory) {
        map[argument.name] = argument.defaultValue();
      }
    }

    return map;
  }

  static Map<String, Object> get invalidProjectName =>
      Map.from(Stub.defaultValues)..[CommandArguments.projectName.name] = '';

  static Map<String, Object> get invalidOrganisation =>
      Map.from(Stub.defaultValues)..[CommandArguments.organisation.name] = '';

  static Map<String, Object> get invalidAuthConfiguration =>
      Map.from(Stub.defaultValues)
        ..[CommandArguments.login.name] = false
        ..[CommandArguments.socialLogins.name] = false
        ..[CommandArguments.otp.name] = true;
}
