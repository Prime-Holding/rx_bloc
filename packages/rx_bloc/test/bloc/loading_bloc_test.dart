import 'package:rx_bloc/rx_bloc.dart';
import 'package:test/test.dart';

// ignore: avoid_relative_lib_imports
import '../../../rx_bloc_test/lib/rx_bloc_test.dart';
// ignore: avoid_relative_lib_imports
import '../../lib/src/bloc/loading_bloc.dart';

void main() {
  group('LoadingBLoc tests', () {
    final tag = 'test_TAG';

    rxBlocTest<LoadingBlocType, Result>(
      'LoadingBLoc test isLoading state',
      build: () async => LoadingBloc(),
      state: (bloc) => bloc.states.result,
      act: (bloc) async {
        bloc.events.setResult(result: Result.loading(tag: tag));

        await Future.delayed(const Duration(milliseconds: 1));
        bloc.events.setResult(result: Result.loading(tag: tag));

        await Future.delayed(const Duration(milliseconds: 1));
        bloc.events.setResult(result: Result.success('result 1', tag: tag));

        await Future.delayed(const Duration(milliseconds: 1));
        bloc.events.setResult(result: Result.success('result 2', tag: tag));

        await Future.delayed(const Duration(milliseconds: 1));
        bloc.events.setResult(result: Result.loading(tag: tag));

        await Future.delayed(const Duration(milliseconds: 1));
        bloc.events.setResult(result: Result.success('result 3', tag: tag));
      },
      // wait: const Duration(milliseconds: 40),
      expect: <Result>[
        Result.success(null),
        Result.loading(tag: tag),
        Result.success('result 2', tag: tag),
        Result.loading(tag: tag),
        Result.success('result 3', tag: tag)
      ],
    );
  });
}
