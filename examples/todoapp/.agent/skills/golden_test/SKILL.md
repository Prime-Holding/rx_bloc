---
description: Create Golden tests for an existing feature.
---

# Create a Golden Test

This skill guides the Agentic Development Environment (e.g., Cursor, Antigravity) in creating golden tests, adhering strictly to the established architecture and structure.

## Inputs Required

To successfully execute this skill, the following inputs MUST be provided:
1. **Feature name** A feature name or its project path 

## Testing Structure (Golden)

The  project expects thorough testing for any new feature. Tests must reside in the `test/` directory, mirroring the structure of `lib/`.

### 1. Global Test Data (Stubs)
Before writing tests, define reusable mock entities in `test/stubs.dart`. This ensures consistency across all unit and golden tests and reduces hardcoded duplicates.
- All mock data elements (e.g., initialized `MyDomainModel` with complete parameters or pre-populated `PaginatedList` objects) must be registered globally as static constants or getters under the `Stubs` class.


### 2. Golden Testing Views & Mock Factories
UI Components and Views must be governed by Golden tests leveraging `alchemist` package. To mock BLoC states effectively without running actual logic, you must construct a test factory structure.

**A. Create Mock Implementations**
In `test/feature_{name}/mock/{name}_mock.dart`, establish dummy BLoC implementations whose state streams simply return explicitly injected values.
```dart
MyFeatureBlocType myFeatureMockFactory({Result<MyDomainModel>? dataResult}) {
  final bloc = MockMyFeatureBlocType();
  final states = MockMyFeatureBlocStates();
  
  when(states.dataResult)
      .thenAnswer((_) => Stream.value(dataResult ?? Result.success(Stubs.mockModel)));
      
  when(bloc.states).thenReturn(states);
  return bloc;
}
```

**B. Create a Widget Factory**
In `test/feature_{name}/factory/{name}_factory.dart`, construct a Wrapper Widget that directly injects the BLoC mock instances from above using `RxBlocProvider`:
```dart
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

Widget myFeatureFactory({
  Result<MyDomainModel>? dataResult,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          RxBlocProvider<MyFeatureBlocType>.value(
            value: myFeatureMockFactory(dataResult: dataResult),
          ),
        ],
        child: const MyFeaturePage(),
      ),
    );
```

**C. Execute Golden Tests**
In `test/feature_{name}/view/{name}_golden_test.dart`, use the factory sequentially for every visual state your UI expects:
```dart
void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'my_feature_loading_state',
      widget: myFeatureFactory(
        dataResult: Result.loading(),
      ),
    ),
    buildScenario(
      scenario: 'my_feature_success_state',
      widget: myFeatureFactory(
        dataResult: Result.success(Stubs.mockModel),
      ),
    ),
    buildScenario(
      scenario: 'my_feature_error_state',
      widget: myFeatureFactory(
        dataResult: Result.error(UnknownErrorModel(exception: Exception('Oops'))),
      ),
    ),
  ]);
}
```

### 5. Finalize
- Run code generation commands (`flutter test --update-goldens`) to generate the golden file specificaly for the implemented golden test

By following these architecture and testing guidelines strictly, you will produce seamless, clean, scalable enhancements fully integrated into the pipeline.
