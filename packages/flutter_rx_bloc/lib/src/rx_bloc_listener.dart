// ignore_for_file: comment_references

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'rx_bloc_provider.dart';

/// Signature for the [listener]
/// function which takes the `BuildContext`
/// along with the [bloc] [state]
/// and is responsible for executing in response to [state] changes.
typedef RxBlocWidgetListener<S> = void Function(BuildContext context, S state);

/// Signature for the [condition] function which takes the previous [state]
/// and the current [state]
/// and is responsible for returning a [bool] which determines whether or not
/// to call [RxBlocWidgetListener]
/// of [RxBlocListener] with the current [state].
typedef RxBlocListenerCondition<S> = bool Function(S? previous, S current);

/// {@template RxBlocListener}
/// Takes a [RxBlocWidgetListener] and an optional [bloc]
/// and invokes the [listener] in response to [state] changes in the [bloc].
/// It should be used for functionality that needs to occur only
/// in response to a [state] change
/// such as navigation, showing a [SnackBar], showing a [Dialog], etc...
/// The [listener] is guaranteed to only be called once for each [state]
/// change unlike the [builder] in [RxBlocBuilder].
///
/// If the [bloc] parameter is omitted, [RxBlocListener] will automatically
/// perform a lookup using [BlocProvider] and the current `BuildContext`.
///
/// ```dart
/// RxBlocListener<BlocA, String>(
///   state: (bloc) => bloc.state.details
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   }
/// )
/// ```
/// Only specify the [bloc] if you wish to provide a [bloc] that is otherwise
/// not accessible via [RxBlocProvider] and the current `BuildContext`.
///
/// ```dart
/// RxBlocListener<BlocAType, String>(
///   bloc: blocA,
///   state: (bloc) => bloc.state.details
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   }
/// )
/// ```
///
/// An optional [condition] can be implemented for more granular control
/// over when [listener] is called.
/// The [condition] function will be invoked on each [bloc] [state] change.
/// The [condition] takes the previous [state] and current [state] and
/// must return a [bool]
/// which determines whether or not the [listener] function will be invoked.
/// The previous [state] will be initialized to the [state] of the [bloc]
/// when the [RxBlocListener] is initialized.
/// [condition] is optional and if it isn't implemented,
/// it will default to `true`.
///
/// ```dart
/// RxBlocListener<BlocA, String>(
///   state: (bloc) => bloc.state.details,
///
///   condition: (previous, current) {
///     // return true/false to determine whether or not
///     // to invoke listener with state
///   },
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   }
/// )
/// ```
///
/// If an error occurs within the provided listened state, an optional [onError]
/// callback will be triggered. In such case, the [listener] callback won't be
/// executed.
/// The [onError] function must be able to be called with either one positional
/// argument, or with two positional arguments where the seconds is always a
/// [StackTrace].
///
/// {@endtemplate}
class RxBlocListener<B extends RxBlocTypeBase, S>
    extends RxBlocListenerBase<B, S> {
  /// {@macro RxBlocListener}
  const RxBlocListener({
    Key? key,
    required RxBlocWidgetListener<S> listener,
    required Stream<S> Function(B) state,
    B? bloc,
    RxBlocListenerCondition<S>? condition,
    Function(BuildContext, S?)? onWaiting,
    void Function(BuildContext, Object, StackTrace)? onError,
    Function(BuildContext)? onComplete,
    S? initialValue,
    Widget child = const SizedBox(),
  }) : super(
          key: key,
          child: child,
          listener: listener,
          bloc: bloc,
          condition: condition,
          state: state,
          initialValue: initialValue,
          onWaiting: onWaiting,
          onError: onError,
          onComplete: onComplete,
        );
}

/// {@template RxBlocListenerBase}
/// Base class for widgets that listen to state changes in a specified [bloc].
///
/// A [RxBlocListenerBase] is stateful and maintains the state subscription.
/// The type of the state and what happens with each state change
/// is defined by sub-classes.
/// {@endtemplate}
abstract class RxBlocListenerBase<B extends RxBlocTypeBase, S>
    extends SingleChildStatefulWidget {
  /// {@macro RxBlocListenerBase}
  const RxBlocListenerBase({
    required this.listener,
    required this.state,
    Key? key,
    this.bloc,
    this.child,
    this.condition,
    this.initialValue,
    this.onError,
    this.onComplete,
    this.onWaiting,
  }) : super(key: key, child: child);

  /// The widget which will be rendered as a descendant
  /// of the [RxBlocListenerBase].
  final Widget? child;

  /// The [bloc] whose [state] will be listened to.
  /// Whenever the [bloc]'s [state] changes, [listener] will be invoked.
  final B? bloc;

  /// The [RxBlocWidgetListener] which will be called on every [state] change.
  /// This [listener] should be used for any code which needs to execute
  /// in response to a [state] change ([Transition]).
  /// The [state] will be the [nextState] for the most recent [Transition].
  final RxBlocWidgetListener<S> listener;

  /// The [RxBlocListenerCondition] that the [RxBlocListenerBase] will invoke.
  /// The [condition] function will be invoked on each [bloc] [state] change.
  /// The [condition] takes the previous [state] and current [state] and
  /// must return a [bool]
  /// which determines whether or not the [listener] function will be invoked.
  /// The previous [state] will be initialized to [state]
  /// when the [RxBlocListenerBase] is initialized.
  /// [condition] is optional and if it isn't implemented,
  /// it will default to `true`.
  final RxBlocListenerCondition<S>? condition;

  /// Stream representing the state which will be listened to for changes
  final Stream<S> Function(B) state;

  /// Callback triggered once any error happens on the listened stream.
  ///
  /// The onError argument may be null, in which case further error events
  /// are considered unhandled, and will be reported to
  /// Zone.handleUncaughtError.
  ///
  /// The provided function is called for all error events from the stream
  /// subscription.
  final void Function(BuildContext, Object, StackTrace)? onError;

  /// Callback executed once the listened state stops emitting values.
  final Function(BuildContext)? onComplete;

  /// Callback triggered once the widget has subscribed to the stream but the
  /// stream hasn't emitted any values yet. If [initialValue] has been specified
  /// it will be available as the second argument of the callback.
  final Function(BuildContext, S?)? onWaiting;

  /// Initial value used in the [onWaiting] callback.
  final S? initialValue;

  @override
  SingleChildState<RxBlocListenerBase<B, S>> createState() =>
      _RxBlocListenerBaseState<B, S>();
}

class _RxBlocListenerBaseState<B extends RxBlocTypeBase, S>
    extends SingleChildState<RxBlocListenerBase<B, S>> {
  // ignore: cancel_subscriptions
  StreamSubscription<S>? _subscription;
  S? _previousState;
  B? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? RxBlocProvider.of<B>(context);
    _subscribe();
  }

  @override
  void didUpdateWidget(RxBlocListenerBase<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldState = oldWidget.bloc ?? RxBlocProvider.of<B>(context);
    final currentState = widget.bloc ?? oldState;
    if (oldState != currentState) {
      if (_subscription != null) {
        _unsubscribe();
        _bloc = widget.bloc ?? RxBlocProvider.of<B>(context);
      }
      _subscribe();
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) => child!;

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (_bloc != null && _subscription == null) {
      _subscription = widget.state(_bloc!).listen(
        (S state) {
          if (widget.condition == null
              ? true
              : widget.condition!.call(_previousState, state)) {
            widget.listener(context, state);
          }

          _previousState = state;
        },
        onError: (Object err, StackTrace st) =>
            widget.onError?.call(context, err, st),
        onDone: () => widget.onComplete?.call(context),
      );
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }
}
