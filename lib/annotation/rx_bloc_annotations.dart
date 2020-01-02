class RxBloc {
  final String eventsClassName;

  final String statesClassName;

  const RxBloc({this.eventsClassName, this.statesClassName});
}

const rxBloc = RxBloc(eventsClassName: null, statesClassName: null);

class RxBlocIgnoreState {
  const RxBlocIgnoreState();
}

const rxBlocIgnoreState = RxBlocIgnoreState();