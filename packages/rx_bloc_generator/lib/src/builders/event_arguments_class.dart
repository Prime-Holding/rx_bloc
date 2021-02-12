part of rx_bloc_generator;

/// Generates class like..
///
/// Example:
/// .. class _EventMethodArgs {
/// ..    _EventMethodArgs({this.argExample});
/// ..    final int argExample;
/// .. }
class _EventArgumentsClass implements _BuilderContract {
  const _EventArgumentsClass(this.method);

  final MethodElement method;

  @override
  Class build() => Class(
        (b) => b
          ..name = '_${method.name.capitalize()}EventArgs'
          ..constructors.add(
            Constructor(
              (b) => b
                ..constant = true
                ..optionalParameters.addAll(
                  method.buildOptionalParameters(toThis: true),
                )
                ..requiredParameters.addAll(
                  method.buildRequiredParameters(toThis: true),
                ),
            ),
          )
          ..fields.addAll(
            method.parameters.map(
              (ParameterElement parameter) => Field(
                (b) => b
                  ..modifier = FieldModifier.final$
                  ..type = refer(
                    parameter.type.getDisplayString(withNullability: false),
                  )
                  ..name = parameter.name,
              ),
            ),
          ),
      );
}
