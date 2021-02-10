part of rx_bloc_generator;

class _EventArgumentsClass implements _RxBlocBuilder {
  _EventArgumentsClass(this.method);

  MethodElement method;

  /// Generates class like..
  /// .. class _EventMethodArgs {
  /// ..    _EventMethodArgs({this.argExample});
  /// ..    final int argExample;
  /// .. }
  @override
  String build() => Class(
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
      ).toDartCodeString();
}
