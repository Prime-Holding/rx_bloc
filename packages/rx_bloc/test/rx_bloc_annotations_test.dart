import 'package:rx_bloc/rx_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('RxBloc Annotations', () {
    test('RxBloc default values', () async {
      const annotation = RxBloc();
      expect(annotation.eventsClassName, 'Events');
      expect(annotation.statesClassName, 'States');
    });

    test('RxBloc custom event/states values', () async {
      const eventsClassName = 'BlocEvent';
      const statesClassName = 'BlocState';
      const annotation = RxBloc(
        eventsClassName: eventsClassName,
        statesClassName: statesClassName,
      );
      expect(annotation.eventsClassName, eventsClassName);
      expect(annotation.statesClassName, statesClassName);
    });

    test('RxBlocEvent default values', () async {
      const event = RxBlocEvent();
      expect(event.type, RxBlocEventType.publish);
      expect(event.seed, null);
    });

    test('RxBlocEvent behaviour type without seed', () async {
      const event = RxBlocEvent(type: RxBlocEventType.behaviour);
      expect(event.type, RxBlocEventType.behaviour);
      expect(event.seed, null);
    });

    test('RxBlocEvent behaviour type with seed', () async {
      const seedValue = 'seed';
      const event = RxBlocEvent(
        type: RxBlocEventType.behaviour,
        seed: seedValue,
      );
      expect(event.type, RxBlocEventType.behaviour);
      expect(event.seed, seedValue);
    });
  });
}
