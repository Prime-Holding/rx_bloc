import 'package:mockito/annotations.dart';
import 'package:reminders/base/common_blocs/firebase_bloc.dart';
import 'package:reminders/lib_router/blocs/router_bloc.dart';

import 'bloc_mocks.mocks.dart';

@GenerateMocks([
  FirebaseBloc,
  RouterBlocType,
])
MockFirebaseBloc createFirebaseBlocMock() => MockFirebaseBloc();
MockRouterBlocType createRouterBlocTypeMock() => MockRouterBlocType();
