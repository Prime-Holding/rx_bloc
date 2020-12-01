import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'rx_bloc_provider.dart';

/// Signature for the [listener] function which takes the `BuildContext` along with the [bloc] [state]
/// and is responsible for executing in response to [state] changes.
typedef RxBlocWidgetListener<S> = void Function(BuildContext context, S state);

/// Signature for the [condition] function which takes the previous [state] and the current [state]
/// and is responsible for returning a [bool] which determines whether or not to call [RxBlocWidgetListener]
/// of [RxBlocListener] with the current [state].
typedef RxBlocListenerCondition<S> = bool Function(S previous, S current);

/// {@template RxBlocListener}
/// Takes a [RxBlocWidgetListener] and an optional [bloc]
/// and invokes the [listener] in response to [state] changes in the [bloc].
/// It should be used for functionality that needs to occur only in response to a [state] change
/// such as navigation, showing a [SnackBar], showing a [Dialog], etc...
/// The [listener] is guaranteed to only be called once for each [state] change unlike the
/// [builder] in [RxBlocBuilder].
///
/// If the [bloc] parameter is omitted, [RxBlocListener] will automatically perform a lookup using
/// [BlocProvider] and the current `BuildContext`.
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
/// not accessible via [BlocProvider] and the current `BuildContext`.
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
/// The [condition] takes the previous [state] and current [state] and must return a [bool]
/// which determines whether or not the [listener] function will be invoked.
/// The previous [state] will be initialized to the [state] of the [bloc]
/// when the [RxBlocListener] is initialized.
/// [condition] is optional and if it isn't implemented, it will default to `true`.
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
/// {@endtemplate}
class RxBlocListener<B extends RxBlocTypeBase, S>
    extends RxBlocListenerBase<B, S> {
  /// The widget which will be rendered as a descendant of the [RxBlocListener].
  final Widget child;

  /// {@macro RxBlocListener}
  const RxBlocListener({
    Key key,
    @required RxBlocWidgetListener<S> listener,
    @required Stream<S> Function(B) state,
    B bloc,
    RxBlocListenerCondition<S> condition,
    this.child = const SizedBox(),
  })  : assert(listener != null),
        super(
          key: key,
          child: child,
          listener: listener,
          bloc: bloc,
          condition: condition,
          state: state,
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
    Key key,
    this.listener,
    this.bloc,
    this.child,
    this.condition,
    this.state,
  }) : super(key: key, child: child);

  /// The widget which will be rendered as a descendant
  /// of the [RxBlocListenerBase].
  final Widget child;

  /// The [bloc] whose [state] will be listened to.
  /// Whenever the [bloc]'s [state] changes, [listener] will be invoked.
  final B bloc;

  /// The [RxBlocWidgetListener] which will be called on every [state] change.
  /// This [listener] should be used for any code which needs to execute
  /// in response to a [state] change ([Transition]).
  /// The [state] will be the [nextState] for the most recent [Transition].
  final RxBlocWidgetListener<S> listener;

  /// The [RxBlocListenerCondition] that the [RxBlocListenerBase] will invoke.
  /// The [condition] function will be invoked on each [bloc] [state] change.
  /// The [condition] takes the previous [state] and current [state] and must return a [bool]
  /// which determines whether or not the [listener] function will be invoked.
  /// The previous [state] will be initialized to [state] when the [RxBlocListenerBase] is initialized.
  /// [condition] is optional and if it isn't implemented, it will default to `true`.
  final RxBlocListenerCondition<S> condition;

  final Stream<S> Function(B) state;

  @override
  SingleChildState<RxBlocListenerBase<B, S>> createState() =>
      _RxBlocListenerBaseState<B, S>();
}

class _RxBlocListenerBaseState<B extends RxBlocTypeBase, S>
    extends SingleChildState<RxBlocListenerBase<B, S>> {
  StreamSubscription<S> _subscription;
  S _previousState;
  B _bloc;

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
  Widget buildWithChild(BuildContext context, Widget child) => child;

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (_bloc != null && _subscription == null) {
      _subscription = widget.state(_bloc).listen((S state) {
        if (widget.condition?.call(_previousState, state) ?? true) {
          widget.listener(context, state);
        }
        _previousState = state;
      });
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}
