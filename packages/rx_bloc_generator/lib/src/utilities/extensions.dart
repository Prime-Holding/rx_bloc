part of rx_bloc_generator;

final _primitives = ['int', 'double', 'Null', 'String', 'bool'];
final _collections = ['List', 'Map', 'Set'];

/// String utilities
extension StringExtensions on String {
  /// region Universal String extension

  /// Returns the index of the [n]th occurrence of a [pattern]
  /// starting from the end of the string.
  /// Returns -1 if the nth occurrence of the string doesn't exist
  int nthIndexReverse(String pattern, int n) {
    var index = length;
    try {
      var i = 0;
      while (i < n) {
        index = lastIndexOf(pattern, index - 1);
        i++;
      }
    } catch (_) {
      index = -1;
    }
    return index;
  }

  /// Removes a character with a given index from the string.
  /// If the index is outside the range, nothing is removed.
  String removeCharacterAt(int index) {
    if (index < 0 || index >= length) return this;
    return '${substring(0, index)}${substring(index + 1)}';
  }

  /// Counts the number of appearances of a pattern
  /// within the range of two indices.
  int count(String pattern, [int startIndex = 0, int endIndex]) {
    endIndex ??= length;
    final substr = substring(startIndex, endIndex);

    var index = 0;
    var count = 0;
    while (index != -1) {
      index = substr.indexOf(pattern, index);
      if (index != -1) {
        count++;
        index += pattern.length;
      }
    }
    return count;
  }

  /// Converts string to red string when printed in terminal
  String toRedString() => '\x1B[31m${this}\x1B[0m';

  /// Checks whether a string contains all the patterns
  bool containsAll(List<String> patterns) {
    return patterns.every(contains);
  }

  /// Capitalizes the first letter of the word
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';

  /// endregion

  ///region Generator specific extensions

  /// Transforms the seed value string into a proper string that can be
  /// used as a BehaviourSubject seed argument
  String convertToValidString() {
    final str = trim()
        ._removeTopLayerCollection()
        .replaceAll(' ', '')
        ._removePrimitiveTypes()
        .replaceAll('=', ':');
    return str._removeCollectionTypes();
  }

  /// When nested collections, removes first found collection,
  /// starting from top layer. Else, it returns the structure as is.
  String _removeTopLayerCollection() {
    var str = trim();
    if (str.containsAll(['(', ')', '<', '>'])) {
      str = str.substring(str.indexOf('(') + 1, str.lastIndexOf(')'));
    }
    return str;
  }

  /// Removes all constructors of primitive types
  String _removePrimitiveTypes() {
    var str = trim();
    _primitives.forEach((itm) {
      final _prim = '$itm(';
      var index = str.indexOf(_prim);
      while (index != -1) {
        str = str.replaceFirst(_prim, '', index).replaceFirst(')', '', index);
        index = str.indexOf(_prim, index + 1);
      }
    });
    return str;
  }

  /// Removes all collection constructors
  String _removeCollectionTypes() {
    var str = trim();

    _collections.forEach((itm) {
      final _coll = itm;
      var index = str.indexOf(_coll);
      while (index != -1) {
        str = str.replaceFirst(
            str.substring(index, str.indexOf('(', index)), '', index);
        str = str._trimBracketPair(startIndex: index);
        index = str.indexOf(_coll);
      }
    });

    return str;
  }

  /// Removes the first bracket pair starting from [startIndex]
  /// preserving the balance of other brackets. If no pair can
  /// be removed, original string is returned
  String _trimBracketPair({int startIndex = 0}) {
    var str = this;
    var index = str.indexOf('(', startIndex);
    if (index == -1) return str;
    var endIndex = str.indexOf(')', index);
    if (endIndex == -1) return str;
    while (index != -1 || endIndex != -1) {
      final substr = str.substring(index + 1, endIndex);
      final startBr = substr.count('(');
      final endBr = substr.count(')');
      if (startBr == endBr) {
        return str
            .replaceFirst('(', '', index)
            .replaceFirst(')', '', endIndex - 1);
      }

      // Reset the end index and move the start index
      endIndex = str.indexOf(')', endIndex + 1);
      if (endIndex == -1) {
        index = str.indexOf('(', index + 1);
        endIndex = str.indexOf(')', index);
      }
    }
    return str;
  }

  /// Returns the type of a value presented as a string
  String getTypeFromString() => substring(0, indexOf('(')).replaceAll(' ', '');

  /// endregion

  /// Returns index of closing brackets balancing other brackets along
  int getIndexOfClosingBracket(int startIndex) {
    final str = substring(startIndex);
    var normal = 1;
    var angle = 0;
    var curly = 0;

    var i = 0;
    while ((normal != 0 || angle != 0 || curly != 0) && i < str.length) {
      var ch = str[i];
      if (ch == '(') normal++;
      if (ch == ')') normal--;
      if (ch == '<') angle++;
      if (ch == '>') angle--;
      if (ch == '{') curly++;
      if (ch == '}') curly--;
      i++;
    }
    if (i == str.length) return -1;
    i--;
    return i + startIndex;
  }

  /// Appends a comma at the end of a string if there's none, if
  /// the string has a valid length. Else, returns an empty string
  String addComaAtEndIfNone() {
    var str = trim();
    if (str.isEmpty) return '';
    str += str[str.length - 1] != ',' ? ',' : '';
    return str;
  }
}

final DartFormatter _dartFormatter = DartFormatter();

extension SpecExtensions on Spec {
  String toDartCodeString() {
    return _dartFormatter.format(
      '${accept(
        DartEmitter(),
      )}',
    );
  }
}

extension _MethodElementExtensions on MethodElement {
  String get generatedFieldName => '_\$${name}Event';

  /// The name of the arguments class that will be generated if
  /// the event contains more than one parameter
  String get argumentsClassName => '_${name.capitalize()}EventArgs';

  ///Returns the stream type based on the number of the parameters of the method
  String get argumentsType {
    if (parameters.length > 1) {
      return argumentsClassName;
    }
    return parameters.isNotEmpty ? parameters.first.type.toString() : 'void';
  }

  List<Parameter> buildOptionalParameters({bool toThis = false}) => parameters
      .where((ParameterElement parameter) => !parameter.isNotOptional)
      .map(
        (ParameterElement parameter) => Parameter(
          (b) => b
            ..toThis = toThis
            ..required = parameter.isRequiredNamed
            ..defaultTo = parameter?.defaultValueCode != null
                ? Code(parameter.defaultValueCode)
                : null
            ..named = parameter.isNamed
            ..name = parameter.name
            ..type = toThis
                ? null // We don't need the type in the constructor
                : refer(
                    parameter.type.toString(),
                  ),
        ),
      )
      .toList();

  List<Parameter> buildRequiredParameters({bool toThis = false}) => parameters
      .where((ParameterElement parameter) => parameter.isNotOptional)
      .map(
        (ParameterElement parameter) => Parameter(
          (b) => b
            ..toThis = toThis
            ..name = parameter.name
            ..type = toThis
                ? null // We don't need the type in the constructor
                : refer(
                    parameter.type.toString(),
                  ),
        ),
      )
      .toList();

  /// Example:
  /// _$[methodName]Event.add()
  Code _streamAddMethodInvoker(Expression argument) =>
      refer(generatedFieldName + '.add').call([argument]).code;

  Code buildBody() {
    List<Parameter> requiredParams = buildRequiredParameters();
    List<Parameter> optionalParams = buildOptionalParameters();
    if (requiredParams.isEmpty && optionalParams.isEmpty) {
      // Provide null if we don't have any arguments
      return _streamAddMethodInvoker(literalNull);
    }

    // Provide first if it's just one required param
    if (optionalParams.isEmpty && requiredParams.length == 1) {
      return _streamAddMethodInvoker(refer(requiredParams.first.name));
    }

    // Provide first if it's just one optional param
    if (requiredParams.isEmpty && optionalParams.length == 1) {
      return _streamAddMethodInvoker(refer(optionalParams.first.name));
    }

    List<Expression> positionalArguments = requiredParams
        .map((Parameter parameter) => refer(parameter.name))
        .toList();

    // Optional and not named are also positional
    for (Parameter param
        in optionalParams.where((Parameter param) => !param.named)) {
      positionalArguments.add(refer(param.name));
    }

    Map<String, Expression> namedArguments = {};
    for (Parameter param
        in optionalParams.where((Parameter param) => param.named)) {
      namedArguments[param.name] = refer(param.name);
    }

    return _streamAddMethodInvoker(
      refer('_${name.capitalize()}EventArgs').newInstance(
        positionalArguments,
        namedArguments,
      ),
    );
  }
}

extension _FieldElementExtensions on FieldElement {
  String get generatedFieldName => '_${name}State';

  String get generatedMethodName => '_mapTo${name.capitalize()}State';
}
