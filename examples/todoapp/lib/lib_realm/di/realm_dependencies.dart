// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../repositories/realm_init_repository.dart';
import '../services/realm_service.dart';

class RealmDependencies {
  RealmDependencies();

  late List<SingleChildWidget> providers = [
    ..._repositories,
    ..._services,
  ];

  List<SingleChildWidget> get _repositories => [
        Provider<RealmInitRepository>(
          create: (context) => RealmInitRepository(
            context.read(),
          ),
        ),
      ];

  List<SingleChildWidget> get _services => [
        Provider<RealmService>(
          create: (context) => RealmService(
            context.read(),
          ),
        ),
      ];
}
