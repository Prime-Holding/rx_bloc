import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:test/test.dart';

// ignore: avoid_relative_lib_imports
import '../../lib/src/bloc/loading_bloc.dart';

void main() {
  group('LoadingBLoc tests', () {
    rxBlocTest<LoadingBlocType, bool>(
      'LoadingBLoc test isLoading state',
      build: () async => LoadingBloc(),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async {
        await Future.delayed(
          const Duration(milliseconds: 10),
          () => bloc.events.setLoading(isLoading: true),
        );

        await Future.delayed(
          const Duration(milliseconds: 10),
          () => bloc.events.setLoading(isLoading: true),
        );

        await Future.delayed(
          const Duration(milliseconds: 10),
          () => bloc.events.setLoading(isLoading: false),
        );

        await Future.delayed(
          const Duration(milliseconds: 10),
          () => bloc.events.setLoading(isLoading: false),
        );

        await Future.delayed(
          const Duration(milliseconds: 10),
          () => bloc.events.setLoading(isLoading: true),
        );

        await Future.delayed(
          const Duration(milliseconds: 10),
          () => bloc.events.setLoading(isLoading: false),
        );
      },
      expect: [false, true, false, true, false],
    );
  });
}
