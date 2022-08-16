import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'test_bloc.rxb.g.dart';

abstract class TestBlocEvents {}

abstract class TestBlocStates {}

@RxBloc()
class TestBloc extends $TestBloc {}
