import 'dart:async';
import 'package:flutter/material.dart';

/// region StreamMultiBuilder3

/// StreamMultiBuilder3 works like a StreamBuilder managing three streams.
class StreamMultiBuilder3<T1, T2, T3> extends _StreamMultiBuilderBase3<T1, T2,
    T3, AsyncSnapshot<T1>, AsyncSnapshot<T2>, AsyncSnapshot<T3>> {
  /// Constructor accepting streams and initial data values
  StreamMultiBuilder3({
    required Stream<T1>? stream1,
    required Stream<T2>? stream2,
    required Stream<T3>? stream3,
    required this.builder,
    super.key,
    T1? initialData1,
    T2? initialData2,
    T3? initialData3,
  }) : super(
          streamContainer1: _StreamContainer(
            stream: stream1,
            initialData: initialData1,
          ),
          streamContainer2: _StreamContainer(
            stream: stream2,
            initialData: initialData2,
          ),
          streamContainer3: _StreamContainer(
            stream: stream3,
            initialData: initialData3,
          ),
        );

  /// Builder
  final _AsyncWidgetBuilder<T1, T2, T3> builder;

  @override
  Widget build(
    BuildContext context,
    AsyncSnapshot<T1> currentSummary1,
    AsyncSnapshot<T2> currentSummary2,
    AsyncSnapshot<T3> currentSummary3,
  ) =>
      builder(context, currentSummary1, currentSummary2, currentSummary3);
}

/// endregion

/// region _StreamMultiBuilderBase3

abstract class _StreamMultiBuilderBase3<T1, T2, T3, S1, S2, S3>
    extends StatefulWidget {
  const _StreamMultiBuilderBase3({
    required this.streamContainer1,
    required this.streamContainer2,
    required this.streamContainer3,
    super.key,
  });

  final _StreamContainerBase<T1, S1> streamContainer1;
  final _StreamContainerBase<T2, S2> streamContainer2;
  final _StreamContainerBase<T3, S3> streamContainer3;

  Widget build(
    BuildContext context,
    S1 currentSummary1,
    S2 currentSummary2,
    S3 currentSummary3,
  );

  @override
  State<_StreamMultiBuilderBase3<T1, T2, T3, S1, S2, S3>> createState() =>
      _StreamMultiBuilderBase3State<T1, T2, T3, S1, S2, S3>();
}

class _StreamMultiBuilderBase3State<T1, T2, T3, S1, S2, S3>
    extends State<_StreamMultiBuilderBase3<T1, T2, T3, S1, S2, S3>> {
  final _subscriptionContainer1 = _StreamSubscriptionContainer<T1, S1>();
  final _subscriptionContainer2 = _StreamSubscriptionContainer<T2, S2>();
  final _subscriptionContainer3 = _StreamSubscriptionContainer<T3, S3>();

  @override
  void initState() {
    super.initState();

    // Setup initial state
    _subscriptionContainer1.summary = widget.streamContainer1.initial();
    _subscriptionContainer2.summary = widget.streamContainer2.initial();
    _subscriptionContainer3.summary = widget.streamContainer3.initial();

    // Setup subscriptions
    _subscriptionContainer1.subscribe(widget.streamContainer1, setState);
    _subscriptionContainer2.subscribe(widget.streamContainer2, setState);
    _subscriptionContainer3.subscribe(widget.streamContainer3, setState);
  }

  @override
  void didUpdateWidget(
      _StreamMultiBuilderBase3<T1, T2, T3, S1, S2, S3> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update subscriptions
    _subscriptionContainer1.update(
        oldWidget.streamContainer1.stream, widget.streamContainer1, setState);
    _subscriptionContainer2.update(
        oldWidget.streamContainer2.stream, widget.streamContainer2, setState);
    _subscriptionContainer3.update(
        oldWidget.streamContainer3.stream, widget.streamContainer3, setState);
  }

  @override
  Widget build(BuildContext context) => widget.build(
        context,
        _subscriptionContainer1.summary,
        _subscriptionContainer2.summary,
        _subscriptionContainer3.summary,
      );

  @override
  void dispose() {
    _subscriptionContainer1.unsubscribe();
    _subscriptionContainer2.unsubscribe();
    _subscriptionContainer3.unsubscribe();
    super.dispose();
  }
}

/// endregion

/// region _StreamContainer

class _StreamContainer<T> extends _StreamContainerBase<T, AsyncSnapshot<T>> {
  _StreamContainer({
    required super.stream,
    this.initialData,
  });

  final T? initialData;

  @override
  AsyncSnapshot<T> initial() => initialData == null
      ? AsyncSnapshot<T>.nothing()
      : AsyncSnapshot<T>.withData(ConnectionState.none, initialData as T);

  @override
  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.waiting);

  @override
  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) =>
      AsyncSnapshot<T>.withData(ConnectionState.active, data);

  @override
  AsyncSnapshot<T> afterError(
          AsyncSnapshot<T> current, Object error, StackTrace stackTrace) =>
      AsyncSnapshot<T>.withError(ConnectionState.active, error, stackTrace);

  @override
  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.done);

  @override
  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.none);
}

/// endregion

/// region _StreamContainerBase

abstract class _StreamContainerBase<T, S> {
  const _StreamContainerBase({required this.stream});

  final Stream<T>? stream;

  S initial();

  S afterConnected(S current);

  S afterData(S current, T data);

  S afterError(S current, Object error, StackTrace stackTrace);

  S afterDone(S current);

  S afterDisconnected(S current);
}

/// endregion

/// region _StreamSubscriptionContainer

class _StreamSubscriptionContainer<T, S> {
  StreamSubscription<T>? subscription; // ignore: cancel_subscriptions
  late S summary;

  void update(
    Stream<T>? oldStream,
    _StreamContainerBase<T, S> streamContainer,
    void Function(void Function()) setState,
  ) {
    if (oldStream != streamContainer.stream) {
      if (subscription != null) {
        unsubscribe();
        summary = streamContainer.afterDisconnected(summary);
      }
      subscribe(streamContainer, setState);
    }
  }

  void subscribe(
    _StreamContainerBase<T, S> streamContainer,
    _StateUpdateFunction setState,
  ) {
    if (streamContainer.stream != null) {
      subscription = streamContainer.stream!.listen((T data) {
        setState(() {
          summary = streamContainer.afterData(summary, data);
        });
      }, onError: (Object error, StackTrace stackTrace) {
        setState(() {
          summary = streamContainer.afterError(summary, error, stackTrace);
        });
      }, onDone: () {
        setState(() {
          summary = streamContainer.afterDone(summary);
        });
      });
      summary = streamContainer.afterConnected(summary);
    }
  }

  void unsubscribe() {
    if (subscription != null) {
      subscription!.cancel();
      subscription = null;
    }
  }
}

/// endregion

/// region _AsyncWidgetBuilder and _StateUpdateFunction

typedef _AsyncWidgetBuilder<T1, T2, T3> = Widget Function(
  BuildContext context,
  AsyncSnapshot<T1> snapshot1,
  AsyncSnapshot<T2> snapshot2,
  AsyncSnapshot<T3> snapshot3,
);

typedef _StateUpdateFunction = void Function(void Function());

/// endregion

/// region Testing

/// Visible for testing
@visibleForTesting
typedef StreamContainerBase<T, S> = _StreamContainerBase<T, S>;

/// Visible for testing
@visibleForTesting
typedef StreamMultiBuilderBase3<T1, T2, T3, S1, S2, S3>
    = _StreamMultiBuilderBase3<T1, T2, T3, S1, S2, S3>;

/// endregion
