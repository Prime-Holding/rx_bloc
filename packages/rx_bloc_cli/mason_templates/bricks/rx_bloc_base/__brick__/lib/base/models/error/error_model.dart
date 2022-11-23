import '../../../assets.dart' show I18nErrorKeys;

part 'error_access_denied_model.dart';
part 'error_connection_refused.dart';
part 'error_generic_model.dart';
part 'error_network_model.dart';
part 'error_no_connection_model.dart';
part 'error_not_found_model.dart';
part 'error_required_field_model.dart';
part 'error_server_model.dart';
part 'error_unknown_model.dart';

class ErrorModel implements Exception {}

abstract class L10nErrorKeyProvider {
  String get l10nErrorKey;
}
