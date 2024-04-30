// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

/// Manager class used to keep track of any registered dependencies
class DependencyInjector {
  static final Map<Type, dynamic> _dependencies = {};

  /// Registers dependency of given type. If entry of existing type exists, it
  /// will be overridden
  T register<T>(T dependency) {
    _dependencies[dependency.runtimeType] = dependency;
    return dependency;
  }

  /// Retrieves dependency of given type
  T get<T>() {
    return _dependencies[T] as T;
  }
}
