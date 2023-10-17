{{> licence.dart }}

import 'package:widget_toolkit/models.dart' as wt_models;
import 'package:widget_toolkit/models.dart' show L10nErrorKeyProvider;

import '../../../assets.dart' show I18nErrorKeys {{#enable_auth_matrix}},I18nFeatureAuthMatrixKeys{{/enable_auth_matrix}};

export 'package:widget_toolkit/models.dart'
    show L10nErrorKeyProvider;

part 'access_denied_error_model.dart';
part 'connection_refused_error_model.dart';
part 'error_server_generic_model.dart';
part 'field_error_model.dart';
part 'field_required_error_model.dart';
part 'network_error_model.dart';
part 'no_connection_error_model.dart';
part 'not_found_error_model.dart';
part 'server_error_model.dart';{{#enable_auth_matrix}}
part 'auth_matrix_canceled_error_model.dart';{{/enable_auth_matrix}}

class ErrorModel extends wt_models.ErrorModel {
    ErrorModel([this.errorLogDetails]);

    final Map<String, String>? errorLogDetails;
}

class UnknownErrorModel extends ErrorModel implements wt_models.UnknownErrorModel {
    UnknownErrorModel({
        this.error,
        this.exception,
        Map<String, String>? errorLogDetails,
    }): super(errorLogDetails);

    @override
    final Error? error;

    @override
    final Exception? exception;
}

class GenericErrorModel extends ErrorModel implements wt_models.GenericErrorModel {
    GenericErrorModel(this.l10nErrorKey, [super.errorLogDetails]);

    @override
    final String l10nErrorKey;
}
