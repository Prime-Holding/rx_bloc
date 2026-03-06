{{> licence.dart }}

{{#has_authentication}}
import '../controllers/authentication_controller.dart';{{/has_authentication}}{{#enable_feature_counter}}
import '../controllers/count_controller.dart';{{/enable_feature_counter}}{{#enable_feature_onboarding}}
import '../controllers/country_codes_controller.dart';{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
import '../controllers/deep_links_controller.dart';{{/enable_feature_deeplinks}}{{#enable_in_app_notifications}}
import '../controllers/in_app_notifications_controller.dart';{{/enable_in_app_notifications}}{{#enable_mfa}}
import '../controllers/mfa_controller.dart';{{/enable_mfa}}{{#enable_forgotten_password}}
import '../controllers/password_reset_controller.dart';{{/enable_forgotten_password}}
import '../controllers/permissions_controller.dart';{{#enable_pin_code}}
import '../controllers/pin_code_controller.dart';{{/enable_pin_code}}
import '../controllers/push_notifications_controller.dart';{{#enable_feature_onboarding}}
import '../controllers/registration_controller.dart';
import '../controllers/users_controller.dart';{{/enable_feature_onboarding}}{{#has_authentication}}
import '../repositories/auth_token_repository.dart';{{/has_authentication}}{{#enable_feature_onboarding}}
import '../repositories/country_codes_repository.dart';{{/enable_feature_onboarding}}{{#enable_in_app_notifications}}
import '../repositories/in_app_notifications_repository.dart';{{/enable_in_app_notifications}}{{#enable_pin_code}}
import '../repositories/pin_code_repository.dart';{{/enable_pin_code}}{{#realtime_communication}}
import '../repositories/sse_repository.dart';{{/realtime_communication}}{{#has_authentication}}
import '../repositories/users_repository.dart';
import '../services/authentication_service.dart';{{/has_authentication}}{{#enable_feature_onboarding}}
import '../services/country_codes_service.dart';{{/enable_feature_onboarding}}{{#enable_pin_code}}
import '../services/pin_code_service.dart';{{/enable_pin_code}}{{#has_authentication}}
import '../services/users_service.dart';{{/has_authentication}}

import '../utils/api_controller.dart';
import '../utils/dependency_injector.dart';

class ServerDependencies{

  /// Registers all dependencies used for the controllers
  static Future<void> registerDependencies(DependencyInjector di) async {
    {{#has_authentication}}
    di.register(AuthTokenRepository());
    di.register(AuthenticationService(di.get()));{{/has_authentication}}{{#enable_pin_code}}
    di.register(PinCodeRepository());
    di.register(PinCodeService(di.get()));{{/enable_pin_code}}{{#has_authentication}}
    di.register(UsersRepository());
    di.register(UsersService(di.get()));{{/has_authentication}}{{#enable_feature_onboarding}}
    di.register(CountryCodesRepository());
    di.register(CountryCodesService(di.get()));{{/enable_feature_onboarding}}{{#enable_in_app_notifications}}
    di.register(InAppNotificationsRepository());{{/enable_in_app_notifications}}{{#realtime_communication}}
    di.register(SseRepository());{{/realtime_communication}}

    /// TODO: Add your dependencies here

  }

  /// Registers all controllers that provide some kind of API
  static Future<void> registerControllers(
      RouteGenerator routeGenerator,
      DependencyInjector di,
      ) async {
    routeGenerator
    {{#enable_feature_counter}}
    ..addController(CountController())
    {{/enable_feature_counter}}{{#has_authentication}}
    ..addController(AuthenticationController(di.get(),di.get())){{/has_authentication}}
    ..addController(PushNotificationsController())
    ..addController(PermissionsController({{#has_authentication}}di.get(),{{#enable_feature_onboarding}} di.get(){{/enable_feature_onboarding}}{{/has_authentication}}))
    {{#enable_feature_deeplinks}}
    ..addController(DeepLinksController())
    {{/enable_feature_deeplinks}}{{#enable_mfa}}
    ..addController(MfaController(di.get()))
    {{/enable_mfa}}{{#enable_pin_code}}
    ..addController(PinCodeController(di.get(), di.get()))
    {{/enable_pin_code}}{{#enable_feature_onboarding}}
    ..addController(UsersController(di.get(), di.get()))
    ..addController(RegistrationController(di.get(), di.get()))
    ..addController(CountryCodesController(di.get()))
    {{/enable_feature_onboarding}}{{#enable_forgotten_password}}
    ..addController(PasswordResetController(di.get())){{/enable_forgotten_password}}{{#enable_in_app_notifications}}
    ..addController(InAppNotificationsController(di.get(), di.get())){{/enable_in_app_notifications}}
  ;

    /// TODO: Add your controllers here

  }

}