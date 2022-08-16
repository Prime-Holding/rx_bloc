import 'package:rx_bloc/rx_bloc.dart';

class TestBloc implements RxBlocTypeBase {
  @override
  void dispose() {}

  Stream<String?> get nullValueStream => Stream.fromIterable([null]);

  Stream<String> get singleValueStream => Stream.fromIterable(['one']);

  Stream<String> get multipleValueStream =>
      Stream.fromIterable(['one', 'two', 'three']);

  Stream<String> get exceptionStream =>
      Stream.fromIterable(['value']).map((_) => throw Exception());
}
