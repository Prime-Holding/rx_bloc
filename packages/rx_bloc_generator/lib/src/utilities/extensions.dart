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
  String toDartCodeString() => _dartFormatter.format(
    '${accept(
      DartEmitter(),
    )}',
  );
}

extension _MethodElementExtensions on MethodElement {
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

  /// Returns the method parameters in a format usable for streams
  String get streamTypeParameters {
    if (parameters.length > 1) {
      var str = '$argumentsClassName(';
      parameterNames.forEach((paramName) => str += ' $paramName:$paramName,');
      str += ')';
      return str;
    }
    return "${parameters.isNotEmpty ? parameters.first.name : 'null'}";
  }

  /// Returns the proper method definition (keeping as well
  /// default values and @required annotations)
  String get definition {
    var def = toString();
    parameterNames.forEach((paramName) {
      final param = getParameter(paramName);

      // Add required annotation before type
      if (param.hasRequired) {
        var index = def.indexOf(paramName);
        index = def.lastIndexOf(param.type.toString(), index);
        def = '${def.substring(0, index)} @required ${def.substring(index)}';
      }

      // Add default value (if any)
      if (param.defaultValueCode != null) {
        var index = def.indexOf(paramName);
        final assignChar = param.isPositional ? '=' : ':';
        def =
        // ignore: lines_longer_than_80_chars
        '${def.substring(0, index)}${def.substring(index, index + paramName.length)}${'$assignChar ${param.defaultValueCode}'}${def.substring(index + paramName.length)}';
      }
    });

    return def;
  }

  /// Returns the parameter instance of a method by its [paramName]
  ParameterElement getParameter(String paramName) {
    return parameters.firstWhere((param) => param.name == paramName);
  }

  /// Returns the list of all parameter names of a method
  List<String> get parameterNames =>
      parameters.map((param) => param.name).toList();
}
