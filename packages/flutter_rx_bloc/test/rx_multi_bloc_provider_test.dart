import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'counter/blocs/counter_bloc.dart';
import 'counter/blocs/test_bloc.dart';

void main() {
  group('RxBlocMultiProvider', () {
    testWidgets('RxBlocMultiProvider children have access to parent providers',
        (tester) async {
      final stringValue = 'value';
      final bloc1 = CounterBloc();
      final bloc2 = TestBloc();
      final k1 = GlobalKey();
      final k2 = GlobalKey();

      final p1 = RxBlocProvider<CounterBlocType>(
        create: (ctx) => bloc1,
        key: k1,
      );
      final p2 = RxBlocProvider<TestBlocType>(
        create: (ctx) => bloc2,
        key: k2,
      );

      final keyChild = GlobalKey();
      await tester.pumpWidget(RxMultiBlocProvider(
        providers: [p1, p2],
        child: Text(
          stringValue,
          key: keyChild,
          textDirection: TextDirection.ltr,
        ),
      ));

      expect(find.text(stringValue), findsOneWidget);

      // Provider 1 does not have access to Provider 1 and Provider 2
      expect(() => RxBlocProvider.of<CounterBlocType>(k1.currentContext!),
          throwsFlutterError);
      expect(() => RxBlocProvider.of<TestBlocType>(k1.currentContext!),
          throwsFlutterError);

      // Provider 2 has access to Provider 1 but not Provider 2
      expect(RxBlocProvider.of<CounterBlocType>(k2.currentContext!), bloc1);
      expect(() => RxBlocProvider.of<TestBlocType>(k2.currentContext!),
          throwsFlutterError);

      // Child has access to both providers and their blocs
      expect(
          RxBlocProvider.of<CounterBlocType>(keyChild.currentContext!), bloc1);
      expect(RxBlocProvider.of<TestBlocType>(keyChild.currentContext!), bloc2);
    });

    testWidgets('RxMultiBlocProvider providers with ignored child',
        (tester) async {
      final text1 = 'Value 1';
      final text2 = 'Value 2';

      final bloc = CounterBloc();
      final p1 = RxBlocProvider.value(
        value: bloc,
        child: Text(text1),
      );

      await tester.pumpWidget(RxMultiBlocProvider(
        providers: [p1],
        child: Text(text2, textDirection: TextDirection.ltr),
      ));

      expect(find.text(text1), findsNothing);
      expect(find.text(text2), findsOneWidget);
    });
  });
}
