import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

part 'sample_bloc.rxb.g.dart';

/// A contract class containing all events of the SampleBloC.
abstract class SampleBlocEvents {
  void fetchData();
}

/// A contract class containing all states of the SampleBloC.
abstract class SampleBlocStates {
  Stream<void> get state0void;

  Stream<String> get state1;

  Stream<String?> get stateNullable1;

  Stream<Result<String>> get stateResult2;

  Stream<List<CustomType>> get stateListOfCustomType;

  Stream<PaginatedList<CustomType2>> get statePaginatedResult3;

  ConnectableStream<bool> get connectableState;
}

@RxBloc()
class SampleBloc extends $SampleBloc {
  final SampleNamedAndResult sampleNamedAndResult;
  final SampleRepository sampleRepo;
  final SampleService sampleService;
  final SampleRequired sampleRequired;

  SampleBloc(
    this.sampleRepo,
    this.sampleService,
    this.sampleRequired, {
    required this.sampleNamedAndResult,
    String? namedNullable,
  });

  @override
  ConnectableStream<bool> _mapToConnectableStateState() {
    throw UnimplementedError();
  }

  @override
  Stream<void> _mapToState0voidState() {
    throw UnimplementedError();
  }

  @override
  Stream<String> _mapToState1State() {
    throw UnimplementedError();
  }

  @override
  Stream<List<CustomType>> _mapToStateListOfCustomTypeState() {
    throw UnimplementedError();
  }

  @override
  Stream<String?> _mapToStateNullable1State() {
    throw UnimplementedError();
  }

  @override
  Stream<PaginatedList<CustomType2>> _mapToStatePaginatedResult3State() {
    throw UnimplementedError();
  }

  @override
  Stream<Result<String>> _mapToStateResult2State() {
    throw UnimplementedError();
  }
}

class SampleRequired {}

class SampleService {}

class SampleRepository {}

class SampleNamedAndResult {}

class CustomType {}

class CustomType2 {}
