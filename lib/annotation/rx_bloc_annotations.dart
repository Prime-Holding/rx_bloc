class RxBloc {
  final String eventsClassName;

  final String statesClassName;

  const RxBloc({this.eventsClassName = "Events", this.statesClassName = "States"});
}

const rxBloc = RxBloc();


class RxBlocIgnoreState {
  const RxBlocIgnoreState();
}

const rxBlocIgnoreState = RxBlocIgnoreState();

class RxBlocEvent {

  final RxBlocEventType type;
  final dynamic seed;

  const RxBlocEvent({this.type = RxBlocEventType.publish, this.seed});
}

enum RxBlocEventType {behaviour, publish}