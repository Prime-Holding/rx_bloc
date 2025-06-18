part of '../../rx_bloc_generator.dart';

// ignore_for_file: deprecated_member_use
// TODO: Remove the ignore once a new version of `source_gen` is released

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
