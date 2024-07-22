{{> licence.dart }}

{{#enable_auth_matrix}}
import '../controllers/auth_matrix_controller.dart';{{/enable_auth_matrix}}{{#has_authentication}}
import '../controllers/authentication_controller.dart';{{/has_authentication}}{{#enable_feature_counter}}
import '../controllers/count_controller.dart';{{/enable_feature_counter}}{{#enable_feature_deeplinks}}
import '../controllers/deep_links_controller.dart';{{/enable_feature_deeplinks}}
import '../controllers/permissions_controller.dart';
import '../controllers/push_notifications_controller.dart';
import '../controllers/translations_controller.dart';{{#enable_auth_matrix}}
import '../repositories/auth_matrix_repository.dart';{{/enable_auth_matrix}}{{#has_authentication}}
import '../repositories/auth_token_repository.dart';{{/has_authentication}}
import '../repositories/translations_repository.dart';{{#enable_auth_matrix}}
import '../services/auth_matrix_service.dart';{{/enable_auth_matrix}}{{#has_authentication}}
import '../services/authentication_service.dart';{{/has_authentication}}
import '../utils/api_controller.dart';
import '../utils/dependency_injector.dart';

class ServerDependencies{

  /// Registers all dependencies used for the controllers
  static Future<void> registerDependencies(DependencyInjector di) async {
    {{#has_authentication}}
    di.register(AuthTokenRepository());
    di.register(AuthenticationService(di.get()));{{/has_authentication}}
    di.register(TranslationsRepository());

    /// TODO: Add your dependencies here

  }

  /// Registers all controllers that provide some kind of API
  static Future<void> registerControllers(
      RouteGenerator routeGenerator,
      DependencyInjector di,
      ) async {
    routeGenerator
      ..addController(TranslationsController(di.get()))
    {{#enable_feature_counter}}
    ..addController(CountController())
    {{/enable_feature_counter}}{{#has_authentication}}
    ..addController(AuthenticationController(di.get())){{/has_authentication}}
    ..addController(PushNotificationsController())
    ..addController(PermissionsController({{#has_authentication}}di.get(){{/has_authentication}}))
    {{#enable_feature_deeplinks}}
    ..addController(DeepLinksController())
    {{/enable_feature_deeplinks}}{{#enable_auth_matrix}}
    ..addController(AuthMatrixController(di.get()))
    {{/enable_auth_matrix}}
    ;

    /// TODO: Add your controllers here

  }

}