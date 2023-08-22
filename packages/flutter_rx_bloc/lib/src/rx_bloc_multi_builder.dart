import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'base/stream_multi_builder_3.dart';
import 'rx_bloc_provider.dart';

/// region RxBlocMultiBuilder2

/// RxBlocMultiBuilder2 is a Flutter widget which requires a [bloc] from the
/// RxBloc ecosystem, a [builder], [state1] and [state2] function.
/// RxBlocMultiBuilder2 handles building the widget in response to new states.
/// RxBlocMultiBuilder2 is very similar to StreamBuilder but has a more simple
/// API to reduce the amount of boilerplate code needed.
///
/// - The builder function will potentially be called many times and should be
/// a pure function that returns a widget in response to the state.
/// - The state function determines which exact state of the bloc will be used.
/// - If the bloc parameter is omitted, RxBlocMultiBuilder2 will automatically
/// perform a lookup using RxBlocProvider and the current BuildContext.
class RxBlocMultiBuilder2<B extends RxBlocTypeBase, T1, T2>
    extends StatelessWidget {
  /// Default RxBlocBuilder constructor
  const RxBlocMultiBuilder2({
    required this.state1,
    required this.state2,
    required this.builder,
    this.bloc,
    Key? key,
  }) : super(key: key);

  /// The [state1] of the bloc that is being listened to for changes
  final Stream<T1> Function(B) state1;

  /// The [state2] of the bloc that is being listened to for changes
  final Stream<T2> Function(B) state2;

  /// The [builder] callback which returns a widget, executed every time there
  /// is a change in the listened state
  final Widget Function(
    BuildContext,
    AsyncSnapshot<T1>,
    AsyncSnapshot<T2>,
    B,
  ) builder;

  /// Optional [bloc] parameter which can be supplied if the specified bloc type
  /// can't be found in the current widget tree. Can be useful if the widget is
  /// inside a `BuildContext` that does not contain a bloc of the specified type
  final B? bloc;

  @override
  Widget build(BuildContext context) {
    final block = bloc ?? RxBlocProvider.of<B>(context);

    return StreamMultiBuilder3<T1, T2, dynamic>(
      stream1: state1(block),
      stream2: state2(block),
      stream3: null,
      builder: (buildContext, snapshot1, snapshot2, _) =>
          builder(buildContext, snapshot1, snapshot2, block),
    );
  }
}

/// endregion

/// region RxBlocMultiBuilder3

/// RxBlocMultiBuilder3 is a Flutter widget which requires a [bloc] from the
/// RxBloc ecosystem, a [builder], [state1], [state2] and [state3] function.
/// RxBlocMultiBuilder3 handles building the widget in response to new states.
/// RxBlocMultiBuilder3 is very similar to StreamBuilder but has a more simple
/// API to reduce the amount of boilerplate code needed.
///
/// - The builder function will potentially be called many times and should be
/// a pure function that returns a widget in response to the state.
/// - The state function determines which exact state of the bloc will be used.
/// - If the bloc parameter is omitted, RxBlocMultiBuilder2 will automatically
/// perform a lookup using RxBlocProvider and the current BuildContext.
class RxBlocMultiBuilder3<B extends RxBlocTypeBase, T1, T2, T3>
    extends StatelessWidget {
  /// Default RxBlocBuilder constructor
  const RxBlocMultiBuilder3({
    required this.state1,
    required this.state2,
    required this.state3,
    required this.builder,
    this.bloc,
    Key? key,
  }) : super(key: key);

  /// The [state1] of the bloc that is being listened to for changes
  final Stream<T1> Function(B) state1;

  /// The [state2] of the bloc that is being listened to for changes
  final Stream<T2> Function(B) state2;

  /// The [state3] of the bloc that is being listened to for changes
  final Stream<T3> Function(B) state3;

  /// The [builder] callback which returns a widget, executed every time there
  /// is a change in the listened state
  final Widget Function(
    BuildContext,
    AsyncSnapshot<T1>,
    AsyncSnapshot<T2>,
    AsyncSnapshot<T3>,
    B,
  ) builder;

  /// Optional [bloc] parameter which can be supplied if the specified bloc type
  /// can't be found in the current widget tree. Can be useful if the widget is
  /// inside a `BuildContext` that does not contain a bloc of the specified type
  final B? bloc;

  @override
  Widget build(BuildContext context) {
    final block = bloc ?? RxBlocProvider.of<B>(context);

    return StreamMultiBuilder3<T1, T2, T3>(
      stream1: state1(block),
      stream2: state2(block),
      stream3: state3(block),
      builder: (buildContext, snapshot1, snapshot2, snapshot3) =>
          builder(buildContext, snapshot1, snapshot2, snapshot3, block),
    );
  }
}

/// endregion
