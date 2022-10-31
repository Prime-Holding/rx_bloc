import 'package:flutter/widgets.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'rx_bloc_provider.dart';

/// RxBlocBuilder is a Flutter widget which requires a [bloc] from the RxBloc
/// ecosystem, a [builder] and a [state] function. RxBlocBuilder handles
/// building the widget in response to new states. RxBlocBuilder is very similar
/// to StreamBuilder but has a more simple API to reduce the amount of
/// boilerplate code needed.
///
/// - The builder function will potentially be called many times and should be
/// a pure function that returns a widget in response to the state.
/// - The state function determines which exact state of the bloc will be used.
/// - If the bloc parameter is omitted, RxBlocBuilder will automatically perform
/// a lookup using RxBlocProvider and the current BuildContext.
class RxBlocBuilder<B extends RxBlocTypeBase, T> extends StatelessWidget {
  /// Default RxBlocBuilder constructor
  const RxBlocBuilder({
    required this.state,
    required this.builder,
    this.bloc,
    Key? key,
  }) : super(key: key);

  /// The [state] of the bloc that is being listened to for changes
  final Stream<T> Function(B) state;

  /// The [builder] callback which returns a widget, executed every time there
  /// is a change in the listened state
  final Widget Function(BuildContext, AsyncSnapshot<T>, B) builder;

  /// Optional [bloc] parameter which can be supplied if the specified bloc type
  /// can't be found in the current widget tree. Can be useful if the widget is
  /// inside a `BuildContext` that does not contain a bloc of the specified type
  final B? bloc;

  @override
  Widget build(BuildContext context) {
    final block = bloc ?? RxBlocProvider.of<B>(context);

    return StreamBuilder<T>(
      stream: state(block),
      builder: (buildContext, snapshot) =>
          builder(buildContext, snapshot, block),
    );
  }
}
