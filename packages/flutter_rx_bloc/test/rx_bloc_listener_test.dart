import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/src/rx_bloc_listener.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/bloc.dart';
import 'rx_bloc_listener_test.mocks.dart';

class CallbackFunctions {
  void onString(BuildContext context, String? value) {}
}

@GenerateMocks([CallbackFunctions])
void main() {
  group('RxBlocListener condition', () {
    testWidgets('listener is called with default condition', (tester) async {
      final callbacks = MockCallbackFunctions();

      await tester.pumpWidget(
        RxBlocListener<TestBloc, String>(
          bloc: TestBloc(),
          state: (bloc) => bloc.singleValueStream,
          listener: callbacks.onString,
        ),
      );

      verify(callbacks.onString(any, any)).called(1);
    });

    testWidgets('listener is always called with true condition',
        (tester) async {
      final callbacks = MockCallbackFunctions();

      await tester.pumpWidget(
        RxBlocListener<TestBloc, String>(
          bloc: TestBloc(),
          state: (bloc) => bloc.multipleValueStream,
          condition: (a, b) => true,
          listener: callbacks.onString,
        ),
      );

      verify(callbacks.onString(any, any)).called(3);
    });

    testWidgets('listener is never called on false condition', (tester) async {
      final callbacks = MockCallbackFunctions();

      await tester.pumpWidget(
        RxBlocListener<TestBloc, String>(
          bloc: TestBloc(),
          state: (bloc) => bloc.singleValueStream,
          condition: (a, b) => false,
          listener: callbacks.onString,
        ),
      );

      verifyNever(callbacks.onString(any, any));
    });

    testWidgets('listener is called only if condition is true', (tester) async {
      final callbacks = MockCallbackFunctions();

      await tester.pumpWidget(
        RxBlocListener<TestBloc, String>(
          bloc: TestBloc(),
          state: (bloc) => bloc.multipleValueStream,
          condition: (a, b) => b == 'two',
          listener: callbacks.onString,
        ),
      );

      verify(callbacks.onString(any, 'two')).called(1);
    });

    testWidgets('listener is called if the stream contains null values',
        (tester) async {
      final callbacks = MockCallbackFunctions();

      await tester.pumpWidget(
        RxBlocListener<TestBloc, String?>(
          bloc: TestBloc(),
          state: (bloc) => bloc.nullValueStream,
          listener: callbacks.onString,
        ),
      );

      verify(callbacks.onString(any, any)).called(1);
    });
  });
}
