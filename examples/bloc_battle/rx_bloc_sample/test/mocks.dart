import 'package:bloc_battle_base/core.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_sample/base/common_blocs/coordinator_bloc.dart';

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
