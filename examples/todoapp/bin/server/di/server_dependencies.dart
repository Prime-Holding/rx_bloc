// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../controllers/permissions_controller.dart';
import '../controllers/translations_controller.dart';
import '../repositories/translations_repository.dart';
import '../utils/api_controller.dart';
import '../utils/dependency_injector.dart';

class ServerDependencies {
  /// Registers all dependencies used for the controllers
  static Future<void> registerDependencies(DependencyInjector di) async {
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
      ..addController(PermissionsController());

    /// TODO: Add your controllers here
  }
}
