import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/src/rx_bloc_extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc/rx_bloc.dart';

void main() {
  group('RxBloc extensions', () {
    test('asException() extension produces valid exception on error', () async {
      final errorText = 'error';
      final exception = Exception(errorText);
      final snapshot1 = AsyncSnapshot<Result<int>>.withError(
        ConnectionState.active,
        exception,
      );
      final snapshot2 = AsyncSnapshot<Result<int>>.withError(
        ConnectionState.active,
        errorText,
      );

      // If exception is passed, it will be returned
      expect(snapshot1.asException(), exception);

      // If non-exception is passed, it will be converted into exception
      expect(snapshot2.asException().toString(), exception.toString());
    });

    test('asException() extension produces no exception on data', () async {
      final snapshot = AsyncSnapshot<Result<int>>.withData(
        ConnectionState.active,
        Result.success(5),
      );

      expect(snapshot.asException(), null);
    });
  });
}
