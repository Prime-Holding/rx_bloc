import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'sample_test.mocks.dart';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';


//TODO @GeneratedMocks([])

void main() {
//TODO

  void _defineWhen(/*value*/) {
     /*
            //Sample mock during a test case
            when(repository.fetchPage()).thenAnswer((_) async => value);
      */
  }

  SampleBloc sampleBloc() => SampleBloc(
//TODO
);
  setUp(() {
  //TODO

  });


  group('test sample_bloc_dart state state0void', () {
      rxBlocTest<SampleBlocType, void>('test sample_bloc_dart state state0void',
      build: () async {
          _defineWhen();
       return sampleBloc();
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.state0void,
      expect: []);
  });

  group('test sample_bloc_dart state state1', () {
      rxBlocTest<SampleBlocType, String>('test sample_bloc_dart state state1',
      build: () async {
          _defineWhen();
       return sampleBloc();
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.state1,
      expect: []);
  });

  group('test sample_bloc_dart state stateNullable1', () {
      rxBlocTest<SampleBlocType, String?>('test sample_bloc_dart state stateNullable1',
      build: () async {
          _defineWhen();
       return sampleBloc();
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.stateNullable1,
      expect: []);
  });

  group('test sample_bloc_dart state stateResult2', () {
      rxBlocTest<SampleBlocType, Result<String>>('test sample_bloc_dart state stateResult2',
      build: () async {
          _defineWhen();
       return sampleBloc();
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.stateResult2,
      expect: []);
  });

  group('test sample_bloc_dart state stateListOfCustomType', () {
      rxBlocTest<SampleBlocType, List<CustomType>>('test sample_bloc_dart state stateListOfCustomType',
      build: () async {
          _defineWhen();
       return sampleBloc();
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.stateListOfCustomType,
      expect: []);
  });

  group('test sample_bloc_dart state statePaginatedResult3', () {
      rxBlocTest<SampleBlocType, PaginatedList<CustomType2>>('test sample_bloc_dart state statePaginatedResult3',
      build: () async {
          _defineWhen();
       return sampleBloc();
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.statePaginatedResult3,
      expect: []);
  });

  group('test sample_bloc_dart state connectableState', () {
      rxBlocTest<SampleBlocType, bool>('test sample_bloc_dart state connectableState',
      build: () async {
          _defineWhen();
       return sampleBloc();
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.connectableState,
      expect: []);
  });

}