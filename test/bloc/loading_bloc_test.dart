import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('Loading bloc', () {
    test('Expecting value from stream', () async {
      final loadingBloc = LoadingBloc();
      final value = false;
      loadingBloc.addStream(BehaviorSubject.seeded(value));
      expectLater(loadingBloc.isLoading, emits(value));
    });

    test('isLoading value changes after delay', () async {
      final loadingBloc = LoadingBloc();
      BehaviorSubject<bool> stream;
      loadingBloc.addStream(stream = BehaviorSubject.seeded(true));
      expectLater(loadingBloc.isLoading, emitsInOrder([false, true]));
      await Future.delayed(Duration(milliseconds: 20), () => stream.add(false));
      expectLater(loadingBloc.isLoading, emitsInOrder([true, false]));
      stream.close();
    });
  });
}
