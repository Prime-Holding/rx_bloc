import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'package:{{project_name}}/feature_counter/blocs/counter_bloc.dart';
import 'package:{{project_name}}/feature_counter/views/counter_page.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';
import 'counter_helper.mocks.dart';

typedef CustomDeviceBuilder = DeviceBuilder Function(WidgetTester);

@GenerateMocks([
  CounterBlocEvents,
  CounterBlocStates,
  CounterBlocType,
])
// these will each get generated as separate golden master files
List<CustomDeviceBuilder> customDeviceBuilders = [
  deviceBuilderWithCounterScenarios,
  deviceBuilderWithErrorScenario,
  deviceBuilderWithLoadingScenario,
];

//test each counter state
DeviceBuilder deviceBuilderWithCounterScenarios(WidgetTester tester) =>
//return a generated DeviceBuilder with specified widget and list of scenarios
    generateDeviceBuilder(
      counterPageFactory(count: 2),
      scenarios: [
        Scenario(name: 'Default'),
      ],
    );

//test error snackbar scenario
DeviceBuilder deviceBuilderWithErrorScenario(WidgetTester tester) =>
    generateDeviceBuilder(
      counterPageFactory(count: 2, error: 'Test errors'),
      scenarios: [
        Scenario(name: 'Error scenario'),
      ],
    );

//test loading animation scenario
DeviceBuilder deviceBuilderWithLoadingScenario(WidgetTester tester) =>
    generateDeviceBuilder(
      counterPageFactory(count: 2, isLoading: true),
      scenarios: [
        Scenario(name: 'Loading scenario'),
      ],
    );

Widget counterPageFactory({String? error, int? count, bool? isLoading}) {
  final counterBloc = MockCounterBlocType();
  final eventsMock = MockCounterBlocEvents();
  final statesMock = MockCounterBlocStates();

  when(counterBloc.events).thenReturn(eventsMock);
  when(counterBloc.states).thenReturn(statesMock);

  final countSubject = BehaviorSubject<int>();
  final errorsSubject = BehaviorSubject<String>();
  final isLoadingSubject = BehaviorSubject<bool>();

  when(statesMock.count).thenAnswer((_) => countSubject);
  when(statesMock.errors).thenAnswer((_) => errorsSubject);
  when(statesMock.isLoading).thenAnswer((_) => isLoadingSubject);

  if (count != null) {
    countSubject.value = count;
  }

  if (isLoading != null) {
    isLoadingSubject.value = isLoading;
  }

  if (error != null) {
    errorsSubject.value = error;
  }

  countSubject.close();
  errorsSubject.close();
  isLoadingSubject.close();

  final providers = [
    Provider<CounterBlocType>(
      create: (context) => counterBloc,
    ),
  ];

  return Builder(
    builder: (context) => MultiProvider(
      providers: providers,
      child: const CounterPage(),
    ),
  );
}
