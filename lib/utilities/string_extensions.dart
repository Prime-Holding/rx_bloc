final _primitives = ['int', 'double', 'Null', 'String', 'bool'];
final _collections = ['List', 'Map', 'Set'];

extension StringExtensions on String {
  /// region Universal String extension

  /// Returns the index of the [n]th occurrence of a [pattern]
  /// starting from the end of the string.
  /// Returns -1 if the nth occurrence of the string doesn't exist
  int nthIndexReverse(String pattern, int n) {
    int index = this.length;
    try {
      int i = 0;
      while (i < n) {
        index = this.lastIndexOf(pattern, index - 1);
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
    if (index < 0 || index >= this.length) return this;
    return '${this.substring(0, index)}${this.substring(index + 1)}';
  }

  /// Counts the number of appearances of a pattern
  /// within the range of two indices.
  int count(String pattern, [int startIndex = 0, int endIndex]) {
    if (endIndex == null) endIndex = this.length;
    final substr = this.substring(startIndex, endIndex);

    int index = 0;
    int count = 0;
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
  String toRedString() {
    return '\x1B[31m' + this + '\x1B[0m';
  }

  /// Checks whether a string contains all the patterns
  bool containsAll(List<String> patterns) {
    return patterns.every((pattern) => this.contains(pattern));
  }

  /// Capitalizes the first letter of the word
  String capitalize() => "${this[0].toUpperCase()}${this.substring(1)}";

  /// endregion

  ///region Generator specific extensions

  /// Transforms the seed value string into a proper string that can be
  /// used as a BehaviourSubject seed argument
  String convertToValidString() {
    final str = this
        .trim()
        ._removeTopLayerCollection()
        .replaceAll(' ', '')
        ._removePrimitiveTypes()
        .replaceAll('=', ':');
    return str._removeCollectionTypes();
  }

  /// When nested collections, removes first found collection,
  /// starting from top layer. Else, it returns the structure as is.
  String _removeTopLayerCollection() {
    var str = this.trim();
    if (str.containsAll(['(', ')', '<', '>']))
      str = str.substring(str.indexOf('(') + 1, str.lastIndexOf(')'));
    return str;
  }

  /// Removes all constructors of primitive types
  String _removePrimitiveTypes() {
    var str = this.trim();
    _primitives.forEach((itm) {
      final _prim = itm + '(';
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
    var str = this.trim();

    _collections.forEach((itm) {
      final _coll = itm;
      int index = str.indexOf(_coll);
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
    int index = str.indexOf('(', startIndex);
    if (index == -1) return str;
    int endIndex = str.indexOf(')', index);
    if (endIndex == -1) return str;
    while (index != -1 || endIndex != -1) {
      final substr = str.substring(index + 1, endIndex);
      final startBr = substr.count('(');
      final endBr = substr.count(')');
      if (startBr == endBr)
        return str
            .replaceFirst('(', '', index)
            .replaceFirst(')', '', endIndex - 1);

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
  String getTypeFromString() {
    return this.substring(0, this.indexOf('(')).replaceAll(' ', '');
  }

  /// endregion

}
