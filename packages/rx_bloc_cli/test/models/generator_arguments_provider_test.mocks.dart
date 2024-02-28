// Mocks generated by Mockito 5.4.2 from annotations
// in rx_bloc_cli/test/models/generator_arguments_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mason_logger/mason_logger.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;
import 'package:rx_bloc_cli/src/models/command_arguments/create_command_arguments.dart'
    as _i4;
import 'package:rx_bloc_cli/src/models/readers/command_arguments_reader.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeLogTheme_0 extends _i1.SmartFake implements _i2.LogTheme {
  _FakeLogTheme_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeProgressOptions_1 extends _i1.SmartFake
    implements _i2.ProgressOptions {
  _FakeProgressOptions_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeProgress_2 extends _i1.SmartFake implements _i2.Progress {
  _FakeProgress_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CommandArgumentsReader].
///
/// See the documentation for Mockito's code generation for more information.
class MockCommandArgumentsReader extends _i1.Mock
    implements _i3.CommandArgumentsReader {
  @override
  T read<T extends Object>(
    _i4.CreateCommandArguments? argument, {
    T Function(T)? validation,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #read,
          [argument],
          {#validation: validation},
        ),
        returnValue: _i5.dummyValue<T>(
          this,
          Invocation.method(
            #read,
            [argument],
            {#validation: validation},
          ),
        ),
        returnValueForMissingStub: _i5.dummyValue<T>(
          this,
          Invocation.method(
            #read,
            [argument],
            {#validation: validation},
          ),
        ),
      ) as T);
}

/// A class which mocks [Logger].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogger extends _i1.Mock implements _i2.Logger {
  @override
  _i2.LogTheme get theme => (super.noSuchMethod(
        Invocation.getter(#theme),
        returnValue: _FakeLogTheme_0(
          this,
          Invocation.getter(#theme),
        ),
        returnValueForMissingStub: _FakeLogTheme_0(
          this,
          Invocation.getter(#theme),
        ),
      ) as _i2.LogTheme);

  @override
  _i2.Level get level => (super.noSuchMethod(
        Invocation.getter(#level),
        returnValue: _i2.Level.verbose,
        returnValueForMissingStub: _i2.Level.verbose,
      ) as _i2.Level);

  @override
  set level(_i2.Level? _level) => super.noSuchMethod(
        Invocation.setter(
          #level,
          _level,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.ProgressOptions get progressOptions => (super.noSuchMethod(
        Invocation.getter(#progressOptions),
        returnValue: _FakeProgressOptions_1(
          this,
          Invocation.getter(#progressOptions),
        ),
        returnValueForMissingStub: _FakeProgressOptions_1(
          this,
          Invocation.getter(#progressOptions),
        ),
      ) as _i2.ProgressOptions);

  @override
  set progressOptions(_i2.ProgressOptions? _progressOptions) =>
      super.noSuchMethod(
        Invocation.setter(
          #progressOptions,
          _progressOptions,
        ),
        returnValueForMissingStub: null,
      );

  @override
  void flush([void Function(String?)? print]) => super.noSuchMethod(
        Invocation.method(
          #flush,
          [print],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void write(String? message) => super.noSuchMethod(
        Invocation.method(
          #write,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void info(
    String? message, {
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #info,
          [message],
          {#style: style},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void delayed(String? message) => super.noSuchMethod(
        Invocation.method(
          #delayed,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.Progress progress(
    String? message, {
    _i2.ProgressOptions? options,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #progress,
          [message],
          {#options: options},
        ),
        returnValue: _FakeProgress_2(
          this,
          Invocation.method(
            #progress,
            [message],
            {#options: options},
          ),
        ),
        returnValueForMissingStub: _FakeProgress_2(
          this,
          Invocation.method(
            #progress,
            [message],
            {#options: options},
          ),
        ),
      ) as _i2.Progress);

  @override
  void err(
    String? message, {
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #err,
          [message],
          {#style: style},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void alert(
    String? message, {
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #alert,
          [message],
          {#style: style},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void detail(
    String? message, {
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #detail,
          [message],
          {#style: style},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void warn(
    String? message, {
    String? tag = r'WARN',
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #warn,
          [message],
          {
            #tag: tag,
            #style: style,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  void success(
    String? message, {
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #success,
          [message],
          {#style: style},
        ),
        returnValueForMissingStub: null,
      );

  @override
  String prompt(
    String? message, {
    Object? defaultValue,
    bool? hidden = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #prompt,
          [message],
          {
            #defaultValue: defaultValue,
            #hidden: hidden,
          },
        ),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);

  @override
  List<String> promptAny(
    String? message, {
    String? separator = r',',
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #promptAny,
          [message],
          {#separator: separator},
        ),
        returnValue: <String>[],
        returnValueForMissingStub: <String>[],
      ) as List<String>);

  @override
  bool confirm(
    String? message, {
    bool? defaultValue = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #confirm,
          [message],
          {#defaultValue: defaultValue},
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  T chooseOne<T extends Object?>(
    String? message, {
    required List<T>? choices,
    T? defaultValue,
    String Function(T)? display,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #chooseOne,
          [message],
          {
            #choices: choices,
            #defaultValue: defaultValue,
            #display: display,
          },
        ),
        returnValue: _i5.dummyValue<T>(
          this,
          Invocation.method(
            #chooseOne,
            [message],
            {
              #choices: choices,
              #defaultValue: defaultValue,
              #display: display,
            },
          ),
        ),
        returnValueForMissingStub: _i5.dummyValue<T>(
          this,
          Invocation.method(
            #chooseOne,
            [message],
            {
              #choices: choices,
              #defaultValue: defaultValue,
              #display: display,
            },
          ),
        ),
      ) as T);

  @override
  List<T> chooseAny<T extends Object?>(
    String? message, {
    required List<T>? choices,
    List<T>? defaultValues,
    String Function(T)? display,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #chooseAny,
          [message],
          {
            #choices: choices,
            #defaultValues: defaultValues,
            #display: display,
          },
        ),
        returnValue: <T>[],
        returnValueForMissingStub: <T>[],
      ) as List<T>);
}
