import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'rx_bloc_provider.dart';

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
  final Widget Function(BuildContext, AsyncSnapshot<T1>, AsyncSnapshot<T2>, B)
      builder;

  /// Optional [bloc] parameter which can be supplied if the specified bloc type
  /// can't be found in the current widget tree. Can be useful if the widget is
  /// inside a `BuildContext` that does not contain a bloc of the specified type
  final B? bloc;

  @override
  Widget build(BuildContext context) {
    final block = bloc ?? RxBlocProvider.of<B>(context);

    return _StreamMultiBuilder2<T1, T2>(
      stream1: state1(block),
      stream2: state2(block),
      builder: (buildContext, snapshot1, snapshot2) =>
          builder(buildContext, snapshot1, snapshot2, block),
    );
  }
}

abstract class _StreamMultiBuilderBase2<T1, T2, S1, S2> extends StatefulWidget {
  const _StreamMultiBuilderBase2({
    super.key,
    required this.stream1,
    required this.stream2,
  });

  final Stream<T1>? stream1;
  final Stream<T2>? stream2;

  S1 initial1();

  S2 initial2();

  S1 afterConnected1(S1 current);

  S2 afterConnected2(S2 current);

  S1 afterData1(S1 current, T1 data);

  S2 afterData2(S2 current, T2 data);

  S1 afterError1(S1 current, Object error, StackTrace stackTrace);

  S2 afterError2(S2 current, Object error, StackTrace stackTrace);

  S1 afterDone1(S1 current);

  S2 afterDone2(S2 current);

  S1 afterDisconnected1(S1 current);

  S2 afterDisconnected2(S2 current);

  Widget build(BuildContext context, S1 currentSummary1, S2 currentSummary2);

  @override
  State<_StreamMultiBuilderBase2<T1, T2, S1, S2>> createState() =>
      _StreamMultiBuilderBase2State<T1, T2, S1, S2>();
}

class _StreamMultiBuilderBase2State<T1, T2, S1, S2>
    extends State<_StreamMultiBuilderBase2<T1, T2, S1, S2>> {
  StreamSubscription<T1>? _subscription1; // ignore: cancel_subscriptions
  StreamSubscription<T2>? _subscription2; // ignore: cancel_subscriptions
  late S1 _summary1;
  late S2 _summary2;

  @override
  void initState() {
    super.initState();
    _summary1 = widget.initial1();
    _summary2 = widget.initial2();
    _subscribe1();
    _subscribe2();
  }

  @override
  void didUpdateWidget(_StreamMultiBuilderBase2<T1, T2, S1, S2> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream1 != widget.stream1) {
      if (_subscription1 != null) {
        _unsubscribe1();
        _summary1 = widget.afterDisconnected1(_summary1);
      }
      _subscribe1();
    }
    if (oldWidget.stream2 != widget.stream2) {
      if (_subscription2 != null) {
        _unsubscribe2();
        _summary2 = widget.afterDisconnected2(_summary2);
      }
      _subscribe2();
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.build(context, _summary1, _summary2);

  @override
  void dispose() {
    _unsubscribe1();
    _unsubscribe2();
    super.dispose();
  }

  void _subscribe1() {
    if (widget.stream1 != null) {
      _subscription1 = widget.stream1!.listen((T1 data) {
        setState(() {
          _summary1 = widget.afterData1(_summary1, data);
        });
      }, onError: (Object error, StackTrace stackTrace) {
        setState(() {
          _summary1 = widget.afterError1(_summary1, error, stackTrace);
        });
      }, onDone: () {
        setState(() {
          _summary1 = widget.afterDone1(_summary1);
        });
      });
      _summary1 = widget.afterConnected1(_summary1);
    }
  }

  void _subscribe2() {
    if (widget.stream2 != null) {
      _subscription2 = widget.stream2!.listen((T2 data) {
        setState(() {
          _summary2 = widget.afterData2(_summary2, data);
        });
      }, onError: (Object error, StackTrace stackTrace) {
        setState(() {
          _summary2 = widget.afterError2(_summary2, error, stackTrace);
        });
      }, onDone: () {
        setState(() {
          _summary2 = widget.afterDone2(_summary2);
        });
      });
      _summary2 = widget.afterConnected2(_summary2);
    }
  }

  void _unsubscribe1() {
    if (_subscription1 != null) {
      _subscription1!.cancel();
      _subscription1 = null;
    }
  }

  void _unsubscribe2() {
    if (_subscription2 != null) {
      _subscription2!.cancel();
      _subscription2 = null;
    }
  }
}

typedef _AsyncWidgetBuilder<T1, T2> = Widget Function(
  BuildContext context,
  AsyncSnapshot<T1> snapshot1,
  AsyncSnapshot<T2> snapshot2,
);

class _StreamMultiBuilder2<T1, T2> extends _StreamMultiBuilderBase2<T1, T2,
    AsyncSnapshot<T1>, AsyncSnapshot<T2>> {
  const _StreamMultiBuilder2({
    super.key,
    this.initialData1,
    this.initialData2,
    required super.stream1,
    required super.stream2,
    required this.builder,
  });

  final _AsyncWidgetBuilder<T1, T2> builder;

  final T1? initialData1;
  final T2? initialData2;

  @override
  AsyncSnapshot<T1> initial1() => initialData1 == null
      ? AsyncSnapshot<T1>.nothing()
      : AsyncSnapshot<T1>.withData(ConnectionState.none, initialData1 as T1);

  @override
  AsyncSnapshot<T2> initial2() => initialData2 == null
      ? AsyncSnapshot<T2>.nothing()
      : AsyncSnapshot<T2>.withData(ConnectionState.none, initialData2 as T2);

  @override
  AsyncSnapshot<T1> afterConnected1(AsyncSnapshot<T1> current) =>
      current.inState(ConnectionState.waiting);

  @override
  AsyncSnapshot<T2> afterConnected2(AsyncSnapshot<T2> current) =>
      current.inState(ConnectionState.waiting);

  @override
  AsyncSnapshot<T1> afterData1(AsyncSnapshot<T1> current, T1 data) {
    return AsyncSnapshot<T1>.withData(ConnectionState.active, data);
  }

  @override
  AsyncSnapshot<T2> afterData2(AsyncSnapshot<T2> current, T2 data) {
    return AsyncSnapshot<T2>.withData(ConnectionState.active, data);
  }

  @override
  AsyncSnapshot<T1> afterError1(
      AsyncSnapshot<T1> current, Object error, StackTrace stackTrace) {
    return AsyncSnapshot<T1>.withError(
        ConnectionState.active, error, stackTrace);
  }

  @override
  AsyncSnapshot<T2> afterError2(
      AsyncSnapshot<T2> current, Object error, StackTrace stackTrace) {
    return AsyncSnapshot<T2>.withError(
        ConnectionState.active, error, stackTrace);
  }

  @override
  AsyncSnapshot<T1> afterDone1(AsyncSnapshot<T1> current) =>
      current.inState(ConnectionState.done);

  @override
  AsyncSnapshot<T2> afterDone2(AsyncSnapshot<T2> current) =>
      current.inState(ConnectionState.done);

  @override
  AsyncSnapshot<T1> afterDisconnected1(AsyncSnapshot<T1> current) =>
      current.inState(ConnectionState.none);

  @override
  AsyncSnapshot<T2> afterDisconnected2(AsyncSnapshot<T2> current) =>
      current.inState(ConnectionState.none);

  @override
  Widget build(BuildContext context, AsyncSnapshot<T1> currentSummary1,
          AsyncSnapshot<T2> currentSummary2) =>
      builder(context, currentSummary1, currentSummary2);
}

/// Visible for testing
@visibleForTesting
typedef StreamMultiBuilderBase2<T1, T2, S1, S2>
    = _StreamMultiBuilderBase2<T1, T2, S1, S2>;

/// Visible for testing
@visibleForTesting
typedef StreamMultiBuilder2<T1, T2> = _StreamMultiBuilder2<T1, T2>;
