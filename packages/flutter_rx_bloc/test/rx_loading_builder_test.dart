import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'counter/blocs/test_bloc.dart';

void main() {
  group('RxLoadingBuilder', () {
    testWidgets('RxLoadingBuilder building based on loading states',
        (tester) async {
      final text1 = 'Is loading';
      final text2 = 'Finished loading';

      final bloc = TestBloc();
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: RxLoadingBuilder<TestBloc>(
            bloc: bloc,
            state: (bloc) => bloc.states.isLoadingWithTag,
            builder: (context, loading, tag, bloc) => Text(
              loading ? text1 : text2,
              key: key,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // RxLoadingBuilder is in loading state if no value has been set
      expect(tester.widget<Text>(find.byKey(key)).data, text1);

      // RxLoadingBuilder loading state is done
      bloc.setLoading(false);
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.byKey(key)).data, text2);
    });

    testWidgets('RxLoadingBuilder building based on tags', (tester) async {
      final tag1 = 'tag 1';
      final tag2 = 'tag 2';

      final bloc = TestBloc();
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: RxLoadingBuilder<TestBloc>(
            bloc: bloc,
            state: (bloc) => bloc.states.isLoadingWithTag,
            builder: (context, loading, tag, bloc) => Text(
              tag,
              key: key,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial loading state has an empty tag
      expect(tester.widget<Text>(find.byKey(key)).data, '');

      // Different tags are properly being picked up
      bloc.setLoading(true, tag: tag1);
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.byKey(key)).data, tag1);

      bloc.setLoading(false, tag: tag2);
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.byKey(key)).data, tag2);
    });
  });
}
