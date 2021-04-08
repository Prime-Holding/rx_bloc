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
          ..docs.addAll([
            '/// Helps providing the arguments in the [Subject.add] for',
            '/// [${method.enclosingElement.name ?? ''}.${method.name}] event'
          ])
          ..name = '_${method.name.capitalize()}EventArgs'
          ..constructors.add(
            Constructor(
              (builder) => builder
                ..constant = true
                ..requiredParameters.addAll(
                    method.parameters.whereRequired().clone(toThis: true))
                ..optionalParameters.addAll(
                    method.parameters.whereOptional().clone(toThis: true)),
            ),
          )
          ..fields.addAll(
            method.parameters.map(
              (ParameterElement parameter) => Field(
                (b) => b
                  ..modifier = FieldModifier.final$
                  ..type = refer(parameter.getTypeDisplayName())
                  ..name = parameter.name,
              ),
            ),
          ),
      );
}
