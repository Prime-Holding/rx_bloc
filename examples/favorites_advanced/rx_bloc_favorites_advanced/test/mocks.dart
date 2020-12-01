import 'package:favorites_advanced_base/repositories.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';

class CoordinatorEventsMock extends Mock implements CoordinatorEvents {}

class CoordinatorStatesMock extends Mock implements CoordinatorStates {}

class CoordinatorBlocMock implements CoordinatorBlocType {
  @override
  void dispose() {}

  @override
  CoordinatorEvents events = CoordinatorEventsMock();

  @override
  CoordinatorStates states = CoordinatorStatesMock();
}

class PuppiesRepositoryMock extends Mock implements PuppiesRepository {}
