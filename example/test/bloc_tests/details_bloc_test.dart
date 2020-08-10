import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/model/result.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../lib/bloc/details_bloc.dart';
import '../../lib/repository/details_repository.dart';

class MockDetailsRepository extends Mock implements DetailsRepository {}

void main() {
  group('CounterBloc tests', () {
    DetailsRepository mockRepo;

    setUp(() {
      mockRepo = MockDetailsRepository();
      when(mockRepo.fetch()).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 60));
        return Future.value('Success');
      });
    });

    //The DetailsBloc starts by automatically fetching data from the Repo,
    //therefore after we make another fetch request we expect to get two loading
    //states and two success states
    rxBlocTest<DetailsBloc, Result<String>>(
      'Fetching details',
      build: () async => DetailsBloc(mockRepo),
      state: (bloc) => bloc.states.details,
      act: (bloc) async => bloc.events.fetch(),
      wait: Duration(milliseconds: 60),
      skip: 0,
      expect: [
        Result<String>.loading(),
        Result<String>.loading(),
        Result.success('Success'),
        Result.success('Success'),
      ],
    );
  });
}
