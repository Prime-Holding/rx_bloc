

![CI](https://github.com/Prime-Holding/rx_bloc/workflows/CI/badge.svg) [![codecov](https://codecov.io/gh/Prime-Holding/rx_bloc/branch/develop/graph/badge.svg)](https://codecov.io/gh/Prime-Holding/rx_bloc/branch/develop) ![style](https://img.shields.io/badge/style-effective_dart-40c4ff.svg) ![license](https://img.shields.io/badge/license-MIT-purple.svg)

# rx_bloc_test

A Flutter package with the goal to enable testing [RxBlocs](https://pub.dev/packages/rx_bloc) from the [FlutterRxBloc package](https://pub.dev/packages/flutter_rx_bloc) with ease.

## rxBlocTest

Testing a specific `RxBloc` state can be done easily with the **rxBlocTest** function. Besides a test description, it has two required parameters: `build`, which should return the testing RxBloc and `state`, which is a specific state inside the provided bloc.

Additionally, like in most cases, the state may return values which can be compared against other values. Here comes the `expect` parameter which takes a list of expected iterables and compares them with the ones from the state.
```dart
rxBlocTest<CounterBloc,int>(
  'Emits [] when created',
  build: () async => CounterBloc(), 
  state: (bloc) => bloc.states.count,
  expect: [],
)
```
There is an `act` parameter which is a callback executed after the bloc has been initialized. It should be used to add events to the block.
```dart
rxBlocTest<CounterBloc,int>(
  'Incrementing value',
  build: () async => CounterBloc(), 
  state: (bloc) => bloc.states.count,
  act: (bloc) async => bloc.events.increment(),
  expect: [1],
)
```
If you want, you can skip a custom amount of values that are emitted by the state by using the `skip` parameter. If no value is provided the default value of 1 is used, which will skip the initial value of the bloc state. The initial value can be included by setting the skip parameter to 0.

There is also a `wait` parameter which will wait for a given Duration to pass. This is useful especially when working with async operations.
```dart
rxBlocTest<DetailsBloc,String>(
  'Fetch third details data',
  build: () async => DetailsBloc(), 
  state: (bloc) => bloc.states.details,
  act: (bloc) async => bloc.events.fetch(),
  wait: Duration(milliseconds:100),
  skip: 3, // This will skip first two values + the initial value
  expect: ['Hello world'],
)
```  

## rxBlocFakeAsyncTest
For the most complex test cases with multiple events, which contain `throttleTime` or/and `debounceTime` or similar inside, and to speed up test execution,`rxBlocFakeAsyncTest` should be used. It contains an instance of [FakeAsync](https://pub.dev/packages/fake_async) inside `act`, which provides a way to fire all asynchronous events that are scheduled for that time period without actually needing the test to wait for real time to elapse.

**Example**

[DetailsBloc](https://github.com/Prime-Holding/rx_bloc/blob/develop/packages/rx_bloc_test/test/helpers/details_bloc/details_bloc.dart) email state mapper: 
```dart
@override
Stream<String> _mapToEmailState() => _$setEmailEvent
  .startWith('')
  .throttleTime(const Duration(seconds: 3), trailing: true)
  .map((email) => email.trim())
  .shareReplay(maxSize: 1);
```

✅ **GOOD - execution time ±35 ms:**
```dart
rxBlocFakeAsyncTest<DetailsBloc, String>(
  'Email fake async test bloc',
  build: () => DetailsBloc(repo),
  state: (bloc) => bloc.states.email,
  act: (bloc, fakeAsync) {
    bloc.events.setEmail(' job');
    bloc.events.setEmail(' job@prime');
    bloc.events.setEmail(' job@prime.com ');
    
    fakeAsync.elapse(const Duration(seconds: 3));
  },
  expect: <String>['', 'job@prime.com'],
);
```


❌ **BAD - execution time ±3 sec:**
```dart
rxBlocTest<DetailsBloc, String>(
  'Email test bloc',
  build: () async => DetailsBloc(repo),
  state: (bloc) => bloc.states.email,
  act: (bloc) async {
    bloc.events.setEmail(' job');
    bloc.events.setEmail(' job@prime');
    bloc.events.setEmail(' job@prime.com ');  
  },
  expect: <String>['', 'job@prime.com'],
);
```
