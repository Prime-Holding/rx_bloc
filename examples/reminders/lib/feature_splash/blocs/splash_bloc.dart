import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/stream_extensions.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';

part 'splash_bloc.rxb.g.dart';

/// A contract class containing all events of the SplashBloC.
abstract class SplashBlocEvents {
  /// Event used to initialize the app specific components
  void initializeApp();
}

/// A contract class containing all states of the SplashBloC.
abstract class SplashBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String?> get errors;
}

@RxBloc()
class SplashBloc extends $SplashBloc {
  SplashBloc(
    RouterBlocType navigationBloc, {
    String? redirectLocation,
  })  : _navigationBloc = navigationBloc,
        _redirectLocation = redirectLocation {
    _$initializeAppEvent
        .throttleTime(const Duration(seconds: 1))
        .startWith(null)
        .switchMap((_) => initializeAppAndNavigate().asResultStream())
        .setResultStateHandler(this)
        .publishReplay(maxSize: 1)
        .connect()
        .addTo(_compositeSubscription);
  }

  final RouterBlocType _navigationBloc;
  final String? _redirectLocation;

  Future<void> initializeAppAndNavigate() async {
    ///TODO: do app initialization here if needed
    await Future.delayed(const Duration(seconds: 3));

    if (_redirectLocation != null) {
      _navigationBloc.events.goToLocation(_redirectLocation!);
    } else {
      _navigationBloc.events.goTo(const LoginRoute());
    }
  }

  @override
  Stream<String?> _mapToErrorsState() => Rx.merge([
        errorState.toMessage(),
        loadingState.where((loading) => loading).map((_) => null),
      ]).share();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
