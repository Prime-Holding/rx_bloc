// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

{{#analytics}}
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';{{/analytics}}
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../feature_counter/bloc/counter_bloc.dart';
import '../repositories/counter_repository.dart';

class CounterDependencies {
CounterDependencies._(this.context);

factory CounterDependencies.of(BuildContext context) =>
CounterDependencies._(context);

final BuildContext context;{{#analytics}}

List<Provider> get _repositories => [
Provider<CounterRepository>(
create: (context) => CounterRepository(),
),
];

List<RxBlocProvider> get _blocs => [
RxBlocProvider<CounterBlocType>(
create: (context) => CounterBloc(context.read()),
),
];

/// List of all providers used throughout the app
List<SingleChildWidget> get providers => [
..._repositories,
..._blocs,
];
}
