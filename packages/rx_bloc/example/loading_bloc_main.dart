// ignore: avoid_relative_lib_imports
import '../lib/src/bloc/loading_bloc.dart';

void main() async {
  /// Create a `CounterBloc` instance.
  final bloc = LoadingBloc();

  /// Listen to the `count` state.
  bloc.states.isLoading.listen((isLoading) {
    print('isLoading -- Count state changed to $isLoading');
  });

  await Future.delayed(
    const Duration(milliseconds: 500),
    () => bloc.events.setLoading(isLoading: true),
  );

  await Future.delayed(
    const Duration(milliseconds: 500),
    () => bloc.events.setLoading(isLoading: true),
  );

  await Future.delayed(
    const Duration(milliseconds: 500),
    () => bloc.events.setLoading(isLoading: false),
  );

  await Future.delayed(
    const Duration(milliseconds: 500),
    () => bloc.events.setLoading(isLoading: true),
  );

  await Future.delayed(
    const Duration(milliseconds: 500),
    () => bloc.events.setLoading(isLoading: false),
  );

  await Future.delayed(
    const Duration(milliseconds: 500),
    () => bloc.events.setLoading(isLoading: false),
  );

  await Future.delayed(
    const Duration(milliseconds: 500),
    () => bloc.events.setLoading(isLoading: true),
  );

  await Future.delayed(
    const Duration(milliseconds: 500),
    () => bloc.events.setLoading(isLoading: false),
  );
}
