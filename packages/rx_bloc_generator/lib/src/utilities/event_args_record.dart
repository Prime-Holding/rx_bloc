part of '../../rx_bloc_generator.dart';

// ignore_for_file: deprecated_member_use
// TODO: Remove the ignore once a new version of `source_gen` is released

class _EventArgsRecord {
  const _EventArgsRecord(this.method);

  final MethodElement method;

  /// The type of record used to wrap the method's parameters
  ///
  /// Used to generate the record type in code:
  /// ```dart
  /// final _$multiplyNumbersEvent = PublishSubject<({int x, int y})>()
  /// ```
  Reference recordType() =>
      RecordType((b) => b..namedFieldTypes.addAll(_namedArguments())).type;

  // NOTE: `RecordType` does not support `newInstance`
  // Because of that an empty string is passed to `refer`
  /// The new instance of a record with the method's parameters
  ///
  /// Used to add a record instance to event subject:
  /// ```dart
  /// void multiplyNumbers(int x, int y) {
  ///    _$multiplyNumbersEvent.add((
  ///        x: x,
  ///        y: y,
  ///    ));
  /// }
  /// ```
  Expression newInstanceWithParameters() => refer('').newInstance(
        [],
        _namedArguments(invocation: true),
      );

  /// Typedef for the record
  ///
  /// Used to provide backwards compatibility for extensions on legacy argument class wrappers
  /// ```dart
  /// typedef _MultiplyNumbersEventArgs = ({int x, int y});
  /// ```
  Spec typeDef() => TypeDef(
        (b) => b
          ..docs.add('// ignore: unused_element')
          ..name = _name
          ..definition = recordType(),
      );

  String get _name => '_${method.name.capitalize()}EventArgs';

  Map<String, Reference> _namedArguments({bool invocation = false}) {
    var params = method.parameters;

    var namedArguments = <String, Reference>{};
    for (var param in params) {
      namedArguments[param.name] =
          invocation ? refer(param.name) : refer(param.getTypeDisplayName());
    }

    return namedArguments;
  }
}
