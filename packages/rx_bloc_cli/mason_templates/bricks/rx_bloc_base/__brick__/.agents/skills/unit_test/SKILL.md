---
description: Create BLoC and Service unit tests for an existing feature - Deterministic, high-signal unit test generation
---

# Create Unit Tests for a Feature

This skill guides the AI agent in creating unit tests for Flutter/Dart services, repositories, and BLoCs, adhering strictly to the established architecture and patterns.

## Inputs Required

To successfully execute this skill, the following inputs MUST be provided:
1. **Feature name:** A feature name or its project path (e.g., `feature_profile` or `lib/feature_profile`)

## Core Principle (Non-Negotiable)

**Correctness > Coverage > Quantity**

The agent must prefer **not generating tests** over generating low-value tests.

## Rule Priority (HIGHEST → LOWEST)

1. **Test Worthiness Gate**
2. **Mandatory Refusal Rules**
3. **Stub & Test Data Rules**
4. **defineWhen() Rules**
5. **Mock Centralization Rules**
6. **Naming & Structure Rules**
7. **Coverage Considerations (always last)**

## Step-by-Step Execution Plan

### 1. AI Test Gate (MANDATORY)

Before generating **any** test code, the agent **MUST** evaluate the target method.

#### Tests MAY be generated **ONLY IF** the method contains at least one of:

* Conditional branching (`if`, `switch`, guards)
* Sorting or ordering logic
* Filtering logic
* Validation or error throwing
* Calculations or transformations
* Aggregation or grouping

#### Tests MUST NOT be generated if the method is:

* A pure pass-through (`return repository.method()`)
* Simple property access (`response.items`)
* A trivial system wrapper (`DateTime.now()`)
* 1:1 data forwarding with no rules

If **uncertain**, the agent MUST assume the code is **NOT test-worthy**.

### 2. Mandatory Refusal Response

If the method does not pass the AI Test Gate, the agent MUST respond with:

> **This [service/method] does not require unit tests.**
>
> **Reason:** [One sentence explaining why it has no business logic.]
>
> **What would need to change for tests to be valuable:** [One sentence describing what logic would justify tests.]

The agent MUST NOT generate:

* Test code
* Mock code
* Placeholder tests
* Coverage-driven tests

### 3. Create Test Structure

Tests must reside in the `test/` directory, mirroring the structure of `lib/`.

#### File Layout Order:

1. Imports
2. `main()`
3. `setUp()`
4. `defineWhen()`
5. `group()` blocks

#### Test File Location:

| Test Type | Location |
|---|---|
| BLoC tests | `test/feature_<name>/blocs/<name>_bloc_test.dart` |
| Service tests | `test/feature_<name>/services/<name>_service_test.dart` |
| Repository tests | `test/base/repositories/<name>_repository_test.dart` |

### 4. Global Test Data (Stubs)

#### ALL test data MUST come from `test/mocks/stubs.dart`

This includes:

* Strings
* Numbers
* IDs
* Model instances
* Lists and collections

#### Forbidden:

* `const` or `final` values inside test files
* Inline model construction in tests
* Hardcoded literals of any kind

If new data is needed, it MUST be added to `stubs.dart`.

### 5. Create Mocks

#### Mock Centralization Rules:

Mocks MUST:
* Be imported from centralized mock files
* Be created using factory functions (`createXMock()`)

Mocks MUST NOT:
* Be generated in test files
* Be instantiated via constructors

If a required mock does not exist, the agent MUST:
1. Add it to the correct centralized mock file
2. Create a factory function
3. Assume `build_runner` will be executed externally

### 6. Implement defineWhen() Helper

If the **same mocked method** is stubbed in **more than one test**, the agent MUST:

* Extract all stubbing into a single `defineWhen()` helper
* Parameterize variations via arguments

Inline stubbing in this case is **always invalid**.

The agent MUST place `defineWhen()`:
* Inside `main()`
* After `setUp()`

### 7. Write Tests

#### Group Naming:

```dart
group('{ServiceName} {methodName} tests', () { ... });
```

#### Test Naming:

```dart
test('test {ServiceName} {methodName} - {scenario}', () { ... });
```

## BLoC Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../mocks/stubs.dart';
import '<bloc_name>_bloc_test.mocks.dart';

@GenerateMocks([
  MyFeatureService,
])
void main() {
  late MyFeatureService service;
  late CoordinatorBlocType coordinatorBloc;
  late CoordinatorBlocStates coordinatorBlocStates;

  void defineWhen({List<MyDomainModel>? items}) {
    items ??= Stubs.mockList;

    when(service.fetchData())
        .thenAnswer((_) => Stream.value(items!));

    when(coordinatorBlocStates.onItemUpdated)
        .thenAnswer((_) => Stream.value(Result.success(Stubs.mockModel)));
  }

  MyFeatureBloc buildBloc() => MyFeatureBloc(
        service,
        coordinatorBloc,
      );

  setUp(() {
    service = MockMyFeatureService();
    coordinatorBlocStates = coordinatorStatesMockFactory();
    coordinatorBloc = coordinatorBlocMockFactory(states: coordinatorBlocStates);
    when(coordinatorBloc.states).thenReturn(coordinatorBlocStates);
  });

  group('MyFeatureBloc fetchData tests', () {
    rxBlocTest<MyFeatureBlocType, Result<List<MyDomainModel>>>(
      'test MyFeatureBloc fetchData - success',
      build: () async {
        defineWhen(items: Stubs.mockList);
        return buildBloc();
      },
      act: (bloc) async => bloc.events.fetchData(),
      state: (bloc) => bloc.states.dataResult,
      expect: [
        Result.success([]),
        Result.loading(),
        Result.success(Stubs.mockList),
      ],
    );

    rxBlocTest<MyFeatureBlocType, Result<List<MyDomainModel>>>(
      'test MyFeatureBloc fetchData - error',
      build: () async {
        when(service.fetchData()).thenThrow(Stubs.error);
        return buildBloc();
      },
      act: (bloc) async => bloc.events.fetchData(),
      state: (bloc) => bloc.states.dataResult,
      expect: [
        Result.success([]),
        Result.loading(),
        Result.error(Stubs.error),
      ],
    );
  });
}
```

## Service Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_repositories.dart';
import '../../mocks/stubs.dart';

void main() {
  late MyFeatureRepository repository;
  late MyFeatureService service;

  void defineWhen({List<MyDomainModel>? items}) {
    items ??= Stubs.mockList;
    when(repository.fetchData()).thenAnswer((_) async => items!);
  }

  setUp(() {
    repository = createMyFeatureRepositoryMock();
    service = MyFeatureService(repository);
  });

  group('MyFeatureService filterActiveItems tests', () {
    test('test MyFeatureService filterActiveItems - filters inactive items', () async {
      defineWhen(items: Stubs.mixedItemsList);
      
      final result = await service.filterActiveItems();
      
      expect(result.length, equals(Stubs.activeItemsCount));
      expect(result.every((item) => item.isActive), isTrue);
    });

    test('test MyFeatureService filterActiveItems - returns empty for no active items', () async {
      defineWhen(items: Stubs.inactiveItemsList);
      
      final result = await service.filterActiveItems();
      
      expect(result, isEmpty);
    });
  });
}
```

## Forbidden Actions (HARD FAILS)

The following actions are **always invalid**:

* Generating tests for pure delegation methods
* Generating tests "just for coverage"
* Using `@GenerateMocks` in test files (use centralized mock files)
* Instantiating mocks directly instead of factory functions
* Defining inline test data in test files
* Repeating the same `when()` stub across multiple tests

## Ambiguous Case Rule

If the agent cannot clearly articulate:

* What business rule is protected, AND
* What production behavior would break

Then the agent MUST NOT generate tests.

## Coverage Rule

Coverage percentage is **irrelevant**.

A service with 0% coverage is **acceptable** if it contains no business logic.

Generating placeholder tests to increase coverage is **forbidden**.

## Finalize

1. **Run build_runner** to generate mock files:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Run tests:**
   ```bash
   flutter test test/feature_<name>/
   ```

## Summary (Agent Execution Model)

1. Evaluate test worthiness
2. If not worthy → refuse using exact template
3. If worthy → follow all structural rules
4. Prefer fewer, meaningful tests
5. When uncertain → do nothing

By following these architecture and testing guidelines strictly, you will produce seamless, clean, scalable unit tests fully integrated into the pipeline.
