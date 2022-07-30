import 'package:flutter/widgets.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'rx_bloc_provider.dart';

/// [RxResultBuilder] handles building a widget in response
/// to new [Result] states
///
/// See also:
///   * [RxBlocBuilder], which handles building the widget in response
///     to new states
///
///   * [StreamBuilder], which delegates to an [AsyncWidgetBuilder] to build
///     itself based on a snapshot from interacting with a [Stream].
class RxResultBuilder<B extends RxBlocTypeBase, T> extends StatelessWidget {
  /// The default constructor.
  const RxResultBuilder({
    required this.state,
    required this.buildSuccess,
    required this.buildError,
    required this.buildLoading,
    this.bloc,
    Key? key,
  }) : super(key: key);

  /// The BLoC state based on which this widget rebuilds itself
  final Stream<Result<T>> Function(B) state;

  ///The [RxBloc] which provides the state for this widget
  final B? bloc;

  /// Callback which is invoked when the [state] stream produces an event
  /// which is [ResultSuccess]
  final Widget Function(BuildContext, T, B) buildSuccess;

  /// Callback which is invoked when the [state] stream produces an event
  /// which is [ResultError]
  ///
  /// If the [AsyncSnapshot] of the stream has an [Exception]
  /// this is called with that [Exception]
  final Widget Function(BuildContext, Exception, B) buildError;

  /// Callback which is invoked when the [state] stream produces an event
  /// which is [ResultLoading]
  ///
  /// This is also called if a build is requested while still waiting for
  /// the first event of the [state] stream
  final Widget Function(BuildContext, B) buildLoading;

  @override
  Widget build(BuildContext context) {
    final block = bloc ?? RxBlocProvider.of<B>(context);

    return StreamBuilder<Result<T>>(
      stream: state(block),
      builder: (buildContext, snapshot) {
        final result = snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done
            ? (snapshot.hasError
                ? Result.error(snapshot.asException()!)
                : snapshot.data)
            : Result.loading();

        if (result is ResultSuccess<T>) {
          return buildSuccess(buildContext, result.data, block);
        } else if (result is ResultError<T>) {
          return buildError(buildContext, result.error, block);
        } else {
          return buildLoading(context, block);
        }
      },
    );
  }
}

extension _AsyncSnapshotToException<T> on AsyncSnapshot<Result<T>> {
  Exception? asException() {
    if (!hasError) return null;

    if (error is Exception) {
      return error as Exception?;
    }

    return Exception(error.toString());
  }
}
