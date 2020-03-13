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
      bloc.registerRequestToLoading(stream);
      expect(bloc.requestsLoadingState, emits(true));
      stream.close();
    });

    test('Exception occured', () async {
      final bloc = BlocImpl();
      final ex = Result.error(Exception('An error occured'));
      final stream = BehaviorSubject.seeded(ex);
      bloc.registerRequestToErrors(stream);
      expect(bloc.requestsExceptions, emits(isA<Exception>()),
          reason: 'reqestsException does not throw an exception, '
              'but rather returns a stream of Exceptions');
      stream.close();
    });
  });
}
