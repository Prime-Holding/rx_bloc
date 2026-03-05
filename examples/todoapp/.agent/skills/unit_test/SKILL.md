---
description: Create BloC and Service unit tests for an existing feature.
---

# Create a Unit Test

This skill guides the Agentic Development Environment (e.g., Cursor, Antigravity) in creating unit tests, adhering strictly to the established architecture and structure.

## Inputs Required

To successfully execute this skill, the following inputs MUST be provided:
1. **Feature name** A feature name or its project path 

## Testing Structure (Unit)

The project expects thorough testing for any new feature. Tests must reside in the `test/` directory, mirroring the structure of `lib/`.

### 1. Global Test Data (Stubs)
Before writing tests, define reusable mock entities in `test/stubs.dart`. This ensures consistency across all unit and golden tests and reduces hardcoded duplicates.
- All mock data elements (e.g., initialized `MyDomainModel` with complete parameters or pre-populated `PaginatedList` objects) must be registered globally as static constants or getters under the `Stubs` class.

### 2. Unit Testing BLoCs
All BLoCs must be unit-tested using `rx_bloc_test` and `mockito`.
- **Location:** `test/feature_{name}/blocs/{name}_bloc_test.dart`
- **Setup:** Create a mock of your Service (e.g., `MockMyFeatureService`) using `@GenerateMocks`. If checking routing or cross-feature coordination, use the globally provided stubs/factories (like `coordinatorBlocMockFactory`).
- **Testing Requirements:** Validate event streams against discrete state transitions (like asserting `Result.loading()` followed by `Result.success(Stubs.mockModel)` inside the `expect:` array).

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../stubs.dart';
import 'my_feature_test.mocks.dart';

@GenerateMocks([
  MyFeatureService,
])
void main() {
  late MyFeatureService service;
  late CoordinatorBlocType coordinatorBloc;
  late CoordinatorStates coordinatorBlocStates;

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

  group('MyFeatureBloc tests', () {
    rxBlocTest<MyFeatureBlocType, Result<List<MyDomainModel>>>(
        'Test successful fetch operation',
        build: () async {
          defineWhen(items: Stubs.mockList);
          return buildBloc();
        },
        act: (bloc) async => bloc.events.fetchData(),
        state: (bloc) => bloc.states.dataResult,
        expect: [
          Result.success([]),
          Result.loading(),
          Result.success(Stubs.mockList)
        ],
    );
  });
}
```



By following these architecture and testing guidelines strictly, you will produce seamless, clean, scalable enhancements fully integrated into the  pipeline.