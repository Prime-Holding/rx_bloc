import 'package:rx_bloc/rx_bloc.dart';

abstract class RxBlocListInterface<T> extends RxBlocTypeBase {
  void loadPage({bool reset = false});

  Stream<List<T>> get paginatedList;

  Stream<bool> get refreshDone;
}
