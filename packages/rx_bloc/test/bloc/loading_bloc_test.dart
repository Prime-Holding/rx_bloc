import 'package:rx_bloc/src/bloc/loading_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

void main() {
  group('Loading bloc', () {
    test('Expecting value from stream', () async {
      final loadingBloc = LoadingBloc();
      final value = false;
      loadingBloc.addStream(BehaviorSubject.seeded(value));
      await expectLater(loadingBloc.isLoading, emits(value));
    });

    test('isLoading value changes after delay', () async {
      final loadingBloc = LoadingBloc();
      BehaviorSubject<bool> stream;
      loadingBloc.addStream(stream = BehaviorSubject.seeded(true));
      await expectLater(loadingBloc.isLoading, emitsInOrder([false, true]));
      await Future.delayed(
        const Duration(milliseconds: 20),
        () => stream.add(false),
      );
      await expectLater(loadingBloc.isLoading, emitsInOrder([true, false]));
      await stream.close();
    });
  });
}
