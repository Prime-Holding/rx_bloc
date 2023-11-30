part of '../../rx_bloc_generator.dart';

/// A mapper that converts a [FieldElement] into an event [Field]
class _CompositionField implements _BuilderContract {
  @override
  Field build() => Field(
        (b) => b
          ..modifier = FieldModifier.final$
          ..name = '_compositeSubscription'
          ..assignment = refer('CompositeSubscription').newInstance(
            [],
          ).code,
      );
}
