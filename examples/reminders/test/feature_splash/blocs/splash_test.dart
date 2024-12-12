import 'package:flutter_test/flutter_test.dart';
import 'package:reminders/feature_splash/blocs/splash_bloc.dart';
import 'package:reminders/lib_router/blocs/router_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../mocks/bloc_mocks.dart';

void main() {
  late RouterBlocType navigationBloc;
  late String? redirectLocation;

  void defineWhen() {}

  SplashBloc splashBloc() => SplashBloc(
        navigationBloc,
        redirectLocation: redirectLocation,
      );
  setUp(() {
    navigationBloc = createRouterBlocTypeMock();
    redirectLocation = '/';
  });

  group('test splash_bloc_dart state isLoading', () {
    rxBlocTest<SplashBlocType, bool>('test splash_bloc_dart state isLoading',
        build: () async {
          defineWhen();
          return splashBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.isLoading,
        expect: [false, true]);
  });

  group('test splash_bloc_dart state errors', () {
    rxBlocTest<SplashBlocType, String?>('test splash_bloc_dart state errors',
        build: () async {
          defineWhen();
          return splashBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.errors,
        expect: const Iterable.empty());
  });
}
