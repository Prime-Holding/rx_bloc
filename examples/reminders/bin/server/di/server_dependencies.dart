// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../controllers/reminders_controller.dart';
import '../repositories/reminders_repository.dart';
import '../services/reminders_service.dart';
import '../utils/api_controller.dart';
import '../utils/dependency_injector.dart';

class ServerDependencies {
  /// Registers all dependencies used for the controllers
  static Future<void> registerDependencies(DependencyInjector di) async {
    di.register(RemindersRepository());
    di.register(RemindersService(di.get()));
  }

  /// Registers all controllers that provide some kind of API
  static Future<void> registerControllers(
    RouteGenerator routeGenerator,
    DependencyInjector di,
  ) async {
    routeGenerator.addController(RemindersController(di.get()));
  }
}
