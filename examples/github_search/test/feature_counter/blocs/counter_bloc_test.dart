// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:github_search/base/models/count.dart';
import 'package:github_search/base/repositories/counter_repository.dart';
import 'package:github_search/feature_counter/blocs/counter_bloc.dart';

import 'counter_bloc_test.mocks.dart';

@GenerateMocks([CounterRepository])
void main() {
  late MockCounterRepository repo;

  setUp(() {
    repo = MockCounterRepository();
  });

  group('CounterBloc tests', () {
    rxBlocTest<CounterBlocType, int>(
      'Initial state',
      build: () async {
        when(repo.getCurrent()).thenAnswer((_) async => Count(0));
        return CounterBloc(repository: repo);
      },
      state: (bloc) => bloc.states.count,
      expect: [0],
    );

    rxBlocTest<CounterBlocType, int>(
      'Incrementing value',
      build: () async {
        when(repo.getCurrent()).thenAnswer((_) async => Count(0));
        when(repo.increment()).thenAnswer((_) async => Count(1));
        return CounterBloc(repository: repo);
      },
      act: (bloc) async => bloc.events.increment(),
      state: (bloc) => bloc.states.count,
      expect: [0, 1],
    );

    rxBlocTest<CounterBlocType, int>(
      'Decrementing value',
      build: () async {
        when(repo.getCurrent()).thenAnswer((_) async => Count(0));
        when(repo.decrement()).thenAnswer((_) async => Count(-1));
        return CounterBloc(repository: repo);
      },
      act: (bloc) async => bloc.events.decrement(),
      state: (bloc) => bloc.states.count,
      expect: [0, -1],
    );

    rxBlocTest<CounterBlocType, int>(
      'Increment and decrement value',
      build: () async {
        when(repo.getCurrent()).thenAnswer((_) async => Count(0));
        when(repo.increment()).thenAnswer((_) async => Count(1));
        when(repo.decrement()).thenAnswer((_) async => Count(0));
        return CounterBloc(repository: repo);
      },
      act: (bloc) async {
        bloc.events.increment();
        bloc.events.decrement();
      },
      state: (bloc) => bloc.states.count,
      expect: [0, 1, 0],
    );

    rxBlocTest<CounterBlocType, String>(
      'Error handling',
      build: () async {
        when(repo.getCurrent()).thenAnswer((_) async => Count(0));
        when(repo.increment()).thenAnswer(
          (_) async => Future.error('test error msg'),
        );
        return CounterBloc(repository: repo);
      },
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
      },
      state: (bloc) => bloc.states.errors,
      expect: [contains('test error msg')],
    );

    rxBlocTest<CounterBlocType, LoadingWithTag>(
      'Loading state',
      build: () async {
        when(repo.getCurrent()).thenAnswer((_) async => Count(0));
        when(repo.increment()).thenAnswer((_) async => Count(1));
        return CounterBloc(repository: repo);
      },
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
      },
      state: (bloc) => bloc.states.isLoading,
      expect: [
        LoadingWithTag(loading: false),
        LoadingWithTag(loading: true, tag: CounterBloc.tagReload),
        LoadingWithTag(loading: false, tag: CounterBloc.tagReload),
        LoadingWithTag(loading: true, tag: CounterBloc.tagIncrement),
        LoadingWithTag(loading: false, tag: CounterBloc.tagIncrement),
      ],
    );
  });
}
