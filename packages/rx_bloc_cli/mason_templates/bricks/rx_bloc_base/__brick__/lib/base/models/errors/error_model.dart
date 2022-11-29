import '../../../assets.dart' show I18nErrorKeys;

part 'access_denied_error_model.dart';
part 'connection_refused_error_model.dart';
part 'field_error_model.dart';
part 'field_required_error_model.dart';
part 'generic_error_model.dart';
part 'network_error_model.dart';
part 'no_connection_error_model.dart';
part 'not_found_error_model.dart';
part 'server_error_model.dart';
part 'unknown_error_model.dart';

class ErrorModel implements Exception {}

abstract class L10nErrorKeyProvider {
  String get l10nErrorKey;
}
