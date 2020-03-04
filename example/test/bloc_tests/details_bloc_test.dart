import 'package:example/bloc/details_bloc.dart';
import 'package:example/repository/details_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

class MockDetailsRepository extends Mock implements DetailsRepository {}

void main() {
  group('CounterBloc tests', () {
    DetailsRepository mockRepo;

    setUp(() {
      mockRepo = MockDetailsRepository();
      when(mockRepo.fetch()).thenAnswer((_) => Future.delayed(
          Duration(milliseconds: 60), () => Future.value('Success')));
    });

    rxBlocTest<DetailsBloc, String>(
      'Fetching details',
      build: () async => DetailsBloc(mockRepo),
      state: (bloc) => bloc.states.details,
      act: (bloc) async => bloc.events.fetch(),
      wait: Duration(milliseconds: 60),
      expect: ['Success'],
    );
  });
}
