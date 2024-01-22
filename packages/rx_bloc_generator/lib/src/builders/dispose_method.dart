part of '../../rx_bloc_generator.dart';

/// Builds the dispose method
/// Example:
///
/// void dispose() {
///   .._${eventMethod1}Event.close();
///   .._${eventMethod2}Event.close();
///   ...
///   ..super.dispose();
/// }
class _DisposeMethod implements _BuilderContract {
  const _DisposeMethod(this.eventMethods);

  final List<MethodElement> eventMethods;

  @override
  Method build() => Method.returnsVoid(
        (b) => b
          ..docs.addAll(['']) // A new line
          ..annotations.add(refer('override'))
          ..name = 'dispose'
          ..body = CodeExpression(
            Block.of([
              ...eventMethods.map(
                (MethodElement method) =>
                    refer('${method.eventFieldName}.close').call([]).statement,
              ),
              refer('_compositeSubscription.dispose').call([]).statement,
              refer('super.dispose').call([]).statement,
            ]),
          ).code,
      );
}
