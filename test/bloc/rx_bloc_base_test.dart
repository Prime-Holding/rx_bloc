import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

// RxBlocBase is abstract. To test it we need its implementation.
class BlocImpl extends RxBlocBase {}

void main() {
  group('RxBlocBase', () {
    test('Request is loading', () async {
      final bloc = BlocImpl();
      final stream = BehaviorSubject.seeded(Result.loading());
      bloc.setLoadingStateHandler(stream);
      expect(bloc.loadingState, emitsInOrder([false, true]));
      stream.close();
    });

    test('Request is loading, stop loading', () async {
      final bloc = BlocImpl();
      final stream = Stream.fromIterable([
        Result.loading(),
        Result.loading(),
        Result.success(null),
      ]);
      bloc.setLoadingStateHandler(stream);
      expect(bloc.loadingState, emitsInOrder([false, true, false]));
    });

    test('Request is loading, stop loading, loading, stop loading', () async {
      final bloc = BlocImpl();
      final stream = Stream.fromIterable([
        Result.loading(),
        Result.success(null),
        Result.success(null),
        Result.loading(),
        Result.success(null),
      ]);
      bloc.setLoadingStateHandler(stream);
      expect(
          bloc.loadingState, emitsInOrder([false, true, false, true, false]));
    });

    test('Exception occured', () async {
      final bloc = BlocImpl();
      final ex = Result.error(Exception('An error occured'));
      final stream = BehaviorSubject.seeded(ex);
      bloc.setErrorStateHandler(stream);
      expect(bloc.errorState, emits(isA<Exception>()),
          reason: 'reqestsException does not throw an exception, '
              'but rather returns a stream of Exceptions');
      stream.close();
    });

    test('Test setResultStateHandler with shareStream enabled', () async {
      int listenCount = 0;
      final bloc = BlocImpl();
      final stream =
          Future.delayed(Duration(milliseconds: 300), () => Future.value(3.14))
              .asResultStream()
              .doOnListen(() {
        listenCount++;
      });
      final data =
          bloc.setResultStateHandler(stream, shareStream: true).whereSuccess();
      expect(bloc.loadingState, emitsInOrder([false, true, false]));
      expect(data, emits(3.14));
      expect(listenCount, 1);
    });

    test(
        'Test setResultStateHandler with shareStream enabled on broadcast stream',
        () async {
      int listenCount = 0;
      final bloc = BlocImpl();
      final stream =
          Future.delayed(Duration(milliseconds: 300), () => Future.value(3.14))
              .asResultStream()
              .asBroadcastStream()
              .doOnListen(() {
        listenCount++;
      });
      final data =
          bloc.setResultStateHandler(stream, shareStream: true).whereSuccess();
      expect(bloc.loadingState, emitsInOrder([false, true, false]));
      expect(data, emits(3.14));
      expect(listenCount, 1);
    });

    test('Test setResultStateHandler with shareStream disabled', () async {
      int listenCount = 0;
      final bloc = BlocImpl();
      final stream = Future.value(3.14).asResultStream().doOnListen(() {
        listenCount++;
      });
      final data =
          bloc.setResultStateHandler(stream, shareStream: false).whereSuccess();
      expect(bloc.loadingState, emitsInOrder([]));
      expect(data, emitsInOrder([]));
      expect(listenCount, 3);
    });

    test(
        'Test setResultStateHandler with shareStream disabled on broadcast stream',
        () async {
      int listenCount = 0;
      final bloc = BlocImpl();
      final stream = Future.value(3.14)
          .asResultStream()
          .asBroadcastStream()
          .doOnListen(() {
        listenCount++;
      });
      final data =
          bloc.setResultStateHandler(stream, shareStream: false).whereSuccess();
      expect(bloc.loadingState, emitsInOrder([]));
      expect(data, emitsInOrder([]));
      expect(listenCount, 3);
    });

    test(
        'Test setResultStateHandler with shareStream enabled doesn\'t share the stream again',
        () async {
      final bloc = BlocImpl();
      final stream = Future.value(3.14).asResultStream().share();
      final streamAfterSettingHandlers =
          bloc.setResultStateHandler(stream, shareStream: true);
      expect(identical(stream, streamAfterSettingHandlers), isTrue);
    });
  });
}
