part of rx_bloc_generator;

/// Generates class like..
///
/// Example:
/// .. class _EventMethodArgs {
/// ..    _EventMethodArgs({this.argExample});
/// ..    final int argExample;
/// .. }
class _EventArgumentsClass implements _BuilderContract {
  const _EventArgumentsClass(this.method) : assert(method != null);

  final MethodElement method;

  @override
  Class build() => Class(
        (b) => b
          ..docs.addAll([
            '/// Helps providing the arguments in the [Subject.add] for',
            '/// [${method.enclosingElement.name ?? ''}.${method.name}] event'
          ])
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
                    parameter.isOptional
                        ? '${parameter.type.getDisplayString(
                            withNullability: false,
                          )}?'
                        : '${parameter.type.getDisplayString(
                            withNullability: false,
                          )}',
                  )
                  ..name = parameter.name,
              ),
            ),
          ),
      );
}
