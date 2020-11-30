import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

// RxBlocBase is abstract. To test it we need its implementation.
class BlocImpl extends RxBlocBase {}

void main() {
  group('RxBlocBase: setLoadingStateHandler', () {
    test('Request is loading with shared stream', () async {
      final bloc = BlocImpl();
      final stream = BehaviorSubject.seeded(Result.loading());
      // ignore: invalid_use_of_protected_member
      bloc.setLoadingStateHandler(stream, shareReplay: true);
      // ignore: invalid_use_of_protected_member
      expect(bloc.loadingState, emitsInOrder([false, true]));
      await stream.close();
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Test setLoadingStateHandler with Publish Stream enabled doesn\'t share the stream again',
        () async {
      final bloc = BlocImpl();
      final stream = Future.value(3.14).asResultStream().share();
      final streamAfterSettingHandlers =
          // ignore: invalid_use_of_protected_member
          bloc.setLoadingStateHandler(stream, shareReplay: false);
      expect(identical(stream, streamAfterSettingHandlers), isTrue);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Test setLoadingStateHandler with Replay Stream enabled doesn\'t share the stream again',
        () async {
      final bloc = BlocImpl();
      final stream =
          Future.value(3.14).asResultStream().shareReplay(maxSize: 1);
      final streamAfterSettingHandlers =
          // ignore: invalid_use_of_protected_member
          bloc.setLoadingStateHandler(stream, shareReplay: true);
      expect(identical(stream, streamAfterSettingHandlers), isTrue);
    });

    test('Request is loading, stop loading', () async {
      final bloc = BlocImpl();
      final stream = Stream.fromIterable([
        Result.loading(),
        Result.loading(),
        Result.success(null),
      ]);
      // ignore: invalid_use_of_protected_member
      bloc.setLoadingStateHandler(stream);
      // ignore: invalid_use_of_protected_member
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
      // ignore: invalid_use_of_protected_member
      bloc.setLoadingStateHandler(stream);
      expect(
          // ignore: invalid_use_of_protected_member
          bloc.loadingState,
          emitsInOrder([false, true, false, true, false]));
    });
  });

  group('RxBlocBase: setErrorStateHandler', () {
    test('Exception occured', () async {
      final bloc = BlocImpl();
      final ex = Result.error(Exception('An error occured'));
      final stream = BehaviorSubject.seeded(ex);
      // ignore: invalid_use_of_protected_member
      bloc.setErrorStateHandler(stream);
      // ignore: invalid_use_of_protected_member
      expect(bloc.errorState, emits(isA<Exception>()),
          reason: 'reqestsException does not throw an exception, '
              'but rather returns a stream of Exceptions');
      await stream.close();
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Test setErrorStateHandler with Replay Stream enabled doesn\'t share the stream again',
        () async {
      final bloc = BlocImpl();
      final stream =
          Future.value(3.14).asResultStream().shareReplay(maxSize: 1);
      final streamAfterSettingHandlers =
          // ignore: invalid_use_of_protected_member
          bloc.setErrorStateHandler(stream, shareReplay: true);
      expect(identical(stream, streamAfterSettingHandlers), isTrue);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Test setErrorStateHandler with Publish Stream enabled doesn\'t share the stream again',
        () async {
      final bloc = BlocImpl();
      final stream = Future.value(3.14).asResultStream().share();
      final streamAfterSettingHandlers =
          // ignore: invalid_use_of_protected_member
          bloc.setErrorStateHandler(stream, shareReplay: false);
      expect(identical(stream, streamAfterSettingHandlers), isTrue);
    });
  });

  group('RxBlocBase: setResultStateHandler', () {
    test('Test setResultStateHandler with shareStream enabled', () async {
      var listenCount = 0;
      final bloc = BlocImpl();
      final stream = Future.delayed(
              const Duration(milliseconds: 300), () => Future.value(3.14))
          .asResultStream()
          .doOnListen(() {
        listenCount++;
      });
      final data =
          // ignore: invalid_use_of_protected_member
          bloc.setResultStateHandler(stream, shareReplay: true).whereSuccess();
      // ignore: invalid_use_of_protected_member
      expect(bloc.loadingState, emitsInOrder([false, true, false]));
      expect(data, emits(3.14));
      expect(listenCount, 1);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Test setResultStateHandler with shareStream enabled on broadcast stream',
        () async {
      var listenCount = 0;
      final bloc = BlocImpl();
      final stream = Future.delayed(
              const Duration(milliseconds: 300), () => Future.value(3.14))
          .asResultStream()
          .asBroadcastStream()
          .doOnListen(() {
        listenCount++;
      });
      final data =
          // ignore: invalid_use_of_protected_member
          bloc.setResultStateHandler(stream, shareReplay: true).whereSuccess();
      // ignore: invalid_use_of_protected_member
      expect(bloc.loadingState, emitsInOrder([false, true, false]));
      expect(data, emits(3.14));
      expect(listenCount, 1);
    });

    test('Test setResultStateHandler with shareStream disabled', () async {
      var listenCount = 0;
      final bloc = BlocImpl();
      final stream = Future.value(3.14).asResultStream().doOnListen(() {
        listenCount++;
      });
      final data =
          // ignore: invalid_use_of_protected_member
          bloc.setResultStateHandler(stream, shareReplay: false).whereSuccess();
      // ignore: invalid_use_of_protected_member
      expect(bloc.loadingState, emitsInOrder([]));
      expect(data, emitsInOrder([]));
      expect(listenCount, 1);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Test setResultStateHandler with shareStream disabled on broadcast stream',
        () async {
      var listenCount = 0;
      final bloc = BlocImpl();
      final stream = Future.value(3.14)
          .asResultStream()
          .asBroadcastStream()
          .doOnListen(() {
        listenCount++;
      });
      final data =
          // ignore: invalid_use_of_protected_member
          bloc.setResultStateHandler(stream, shareReplay: false).whereSuccess();
      // ignore: invalid_use_of_protected_member
      expect(bloc.loadingState, emitsInOrder([]));
      expect(data, emitsInOrder([]));
      expect(listenCount, 1);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Test setResultStateHandler with Replay Stream enabled doesn\'t share the stream again',
        () async {
      final bloc = BlocImpl();
      final stream =
          Future.value(3.14).asResultStream().shareReplay(maxSize: 1);
      final streamAfterSettingHandlers =
          // ignore: invalid_use_of_protected_member
          bloc.setResultStateHandler(stream, shareReplay: true);
      expect(identical(stream, streamAfterSettingHandlers), isTrue);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Test setResultStateHandler with Publish Stream enabled doesn\'t share the stream again',
        () async {
      final bloc = BlocImpl();
      final stream = Future.value(3.14).asResultStream().share();
      final streamAfterSettingHandlers =
          // ignore: invalid_use_of_protected_member
          bloc.setResultStateHandler(stream, shareReplay: false);
      expect(identical(stream, streamAfterSettingHandlers), isTrue);
    });
  });
}
