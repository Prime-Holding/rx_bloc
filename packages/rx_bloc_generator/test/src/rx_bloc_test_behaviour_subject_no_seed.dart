@Tags(['not-tests'])
import 'package:rx_bloc/rx_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen_test/annotations.dart';
import 'package:test/test.dart';

@ShouldGenerate('part of \'rx_bloc_test_behaviour_subject_no_seed.dart\';\n'
    '\n'
    '/// Used as a contractor for the bloc, events and states classes\n'
    '/// {@nodoc}\n'
    'abstract class CounterBlocType extends RxBlocTypeBase {\n'
    '  CounterBlocEvents get events;\n'
    '  CounterBlocStates get states;\n'
    '}\n'
    '\n'
    '/// [\$CounterBloc] extended by the [CounterBloc]\n'
    '/// {@nodoc}\n'
    'abstract class \$CounterBloc extends RxBlocBase\n'
    '    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {\n'
    '  final _compositeSubscription = CompositeSubscription();\n'
    '\n'
    '  /// Тhe [Subject] where events sink to by calling [test]\n'
    '  final _\$testEvent = BehaviorSubject<int>();\n'
    '\n'
    '  @override\n'
    '  void test(int test) => _\$testEvent.add(test);\n'
    '\n'
    '  @override\n'
    '  CounterBlocEvents get events => this;\n'
    '\n'
    '  @override\n'
    '  CounterBlocStates get states => this;\n'
    '\n'
    '  @override\n'
    '  void dispose() {\n'
    '    _\$testEvent.close();\n'
    '    _compositeSubscription.dispose();\n'
    '    super.dispose();\n'
    '  }\n'
    '}\n'
    '')
@RxBloc()
class CounterBloc {}

/// A contract class containing all events.
abstract class CounterBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void test(int test);
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {}
