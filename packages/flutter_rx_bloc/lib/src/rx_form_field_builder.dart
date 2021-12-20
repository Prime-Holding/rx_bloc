import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../flutter_rx_bloc.dart';
import '../rx_form.dart';
import 'rx_field_exception.dart';

part 'rx_text_form_field_builder.dart';

typedef RxFormFieldState<B extends RxBlocTypeBase, T> = Stream<T> Function(B);

typedef RxFormFieldShowError<B extends RxBlocTypeBase> = Stream<bool> Function(
    B);

typedef RxFormFieldOnChanged<B extends RxBlocTypeBase, T> = void Function(B, T);

typedef RxFormFieldBuilderFunction<B extends RxBlocTypeBase, T>
    = Widget Function(
        RxFormFieldBuilderState<B, T, RxFormFieldBuilder<B, T>> fieldState);

///   [RxFormFieldBuilder] is a convenience widget,
/// which makes it easier to build and update responsive form fields
/// with reactive [Stream]s.
///
///   It requires a [state] callback, which returns a [Stream] of values,
/// and can emmit errors which have to be of type [RxFieldException].
/// The values and errors are provided to the [builder] function
/// in order to be displayed.
///
///   If the [state] [Stream] emits an error that error is provided
/// to the [builder] function in order to be displayed.
///
///   Important! - any errors emitted by the [state] [Stream],
/// must be of type [RxFieldException]. The reason for this requirement
/// is that [RxFieldException] provides a value field as well as an error field,
/// and thus the value provided to the [builder]
/// is kept and not lost upon update.
///
///   It requires a [showErrorState] callback, which returns a [Stream] of
/// boolean values which determine when it is time to show any potential errors.
///   !The stream provided by [showErrorState] must never emmit an error.
///
///   A [builder] function is required, this is a function which gives you
/// access to the current field state, and must return a [Widget].
///
///   The field state provided to the builder function contains several useful
/// fields: bloc, value, error and showError; reference the documentation
/// of [RxFormFieldBuilderState] for more information on those fields.
///
///   You can optionally provide an [RxBloc] to the [bloc] field, if you do
/// the provided bloc would be used, otherwise [RxFormFieldBuilder]
/// automatically searches for and uses the closest instance up the widget tree
/// of [RxBloc] of type [B].
///
///  This is an example of how to make a radio button form field.
///
///  ```dart
///  Widget build(BuildContext context) =>
///      RxFormFieldBuilder<ColorSelectionBlocType, ColorEnum>(
///        state: (bloc) => bloc.states.color,
///        showErrorState: (bloc) => bloc.states.showErrors,
///        builder: (fieldState) => Column(
///          children: [
///            Row(
///              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
///              children: [
///                Row(
///                  children: [
///                    const Text(
///                      'White',
///                    ),
///                    Radio<Gender>(
///                      value: ColorEnum.white,
///                      groupValue: fieldState.value,
///                      onChanged: fieldState.bloc.events.setColor,
///                    ),
///                  ],
///                ),
///                Row(
///                  children: [
///                    const Text(
///                      'Black',
///                    ),
///                    Radio<Gender>(
///                      value: ColorEnum.black,
///                      groupValue: fieldState.value,
///                      onChanged: fieldState.bloc.events.setColor,
///                    ),
///                  ],
///                ),
///              ],
///            ),
///            //show errors, say for instance the user tries to save the
///            //changes to the form, but they forgot to select a color.
///            if (fieldState.showError)
///              Row(
///                children: [
///                  Text(
///                    fieldState.error,
///                  ),
///                ],
///              ),
///          ],
///        ),
///      );
///  ```
///
///  This is an example of a drop down menu form field.
///
///  ```dart
///  Widget build(BuildContext context) =>
///      RxFormFieldBuilder<ColorSelectionBlocType, ColorEnum>(
///        state: (bloc) => bloc.states.color,
///        showErrorState: (bloc) => bloc.states.showErrors,
///        builder: (fieldState) => Column(
///          children: [
///            Center(
///              child: DropdownButton<ColorEnum>(
///                value: fieldState.value,
///                onChanged: fieldState.bloc.events.setColor,
///                items: ColorEnum.values
///                    .map(
///                      (color) => DropdownMenuItem<ColorEnum>(
///                        value: color,
///                        child: Text(
///                          color.toString(),
///                        ),
///                      ),
///                    )
///                    .toList(),
///              ),
///            ),
///            //show errors, say for instance the user tries to save the
///            //changes to the form, but they forgot to select a color.
///            if (fieldState.showError)
///              Row(
///                children: [
///                  Text(
///                    fieldState.error,
///                  ),
///                ],
///              ),
///          ],
///         ),
///      );
///  ```
class RxFormFieldBuilder<B extends RxBlocTypeBase, T> extends StatefulWidget {
  ///The default constructor
  const RxFormFieldBuilder({
    required this.state,
    required this.showErrorState,
    required this.builder,
    this.bloc,
    Key? key,
  }) : super(key: key);

  /// A [state] callback, which returns a [Stream] of values
  /// which are provided to the [builder] function in order to be
  /// displayed.
  final RxFormFieldState<B, T> state;

  /// A [showErrorState] callback, which returns a [Stream] of boolean
  /// values which determine when it is time to show any potential errors.
  ///   !The stream provided by [showErrorState] must never emmit an error.
  final RxFormFieldShowError<B> showErrorState;

  /// A [builder] function is required, this is a function which gives you
  /// access to the current field state, and must return a [Widget].
  final RxFormFieldBuilderFunction<B, T> builder;

  ///You can optionally provide an [RxBloc] to the [bloc] field, if you do
  ///the provided bloc would be used, otherwise [RxFormFieldBuilder]
  ///automatically searches for and uses the closest instance up the widget tree
  ///of [RxBloc] of type [B].
  final B? bloc;

  @override
  RxFormFieldBuilderState createState() =>
      RxFormFieldBuilderState<B, T, RxFormFieldBuilder<B, T>>();
}

///   [RxFormFieldBuilderState] is the field state provided
/// to the builder function of [RxFormFieldBuilder].
///
/// it Contains several useful fields: [bloc], [value], [error] and [showError];
///
///   The [bloc] field gives you access to the [RxBloc] from which the
/// field state is derived, it should be mostly used in order to
/// fire off events towards the bloc, in response to user interaction
/// with the form field.
///
///   The [value] field is the most current value from the state stream.
///
///   The [error] field holds the most recent error from the state stream,
/// !it gets assigned null if a value gets emitted by the state stream.
///
///   The [showError] field provides the latest boolean value
/// from the showErrorState stream, use it to determine when you should start
/// showing errors to the user.
///
///   !The showErrorState stream must never emmit an error
class RxFormFieldBuilderState<B extends RxBlocTypeBase, T,
    R extends RxFormFieldBuilder<B, T>> extends State<R> {
  late B _bloc;
  late Stream<T?> _blocState;
  late Stream<bool> _showErrorState;

  T? _value;
  String? _error = '';
  bool _showError = false;

  RxFormFieldBuilderFunction<B, T> get _builder => widget.builder;

  final _compositeSubscription = CompositeSubscription();

  /// The [bloc] field gives you access to the [RxBloc]
  /// from which the field state is derived, it should be mostly used
  /// in order to fire off events towards the bloc,
  /// in response to user interaction with the form field.
  ///
  /// The returned bloc is either the bloc passed to the constructor
  /// of the widget, or if one isn't provided [RxFormFieldBuilder]
  /// automatically searches for and uses the closest instance
  /// up the widget tree of [RxBloc] of type [B].
  B get bloc => _bloc;

  /// The [value] field is the most current value from the state stream.
  /// If everything is done right, this should basically never be null,
  /// you should provide initial value to the state stream
  /// from the implementation of the bloc.
  T? get value => _value;

  /// The [error] field holds the most recent error from the state stream,
  /// !it gets assigned null if a value gets emitted by the state stream.
  String? get error => _error;

  /// The [showError] field provides the latest boolean value
  /// from the showErrorState stream, use it to determine when you should
  /// show errors to the user.
  bool get showError => _showError && error != null;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? RxBlocProvider.of<B>(context);
    _blocState = widget.state(_bloc);
    _showErrorState = widget.showErrorState(_bloc);

    _blocState.listen((value) {
      setState(() {
        _error = null;
        _value = value;
      });
    }, onError: (exception) {
      assert(
        exception is RxFieldException<T>,
        'Actual: Exception is [${exception.runtimeType}], '
        '${exception.toString()} \n'
        'Exceptions thrown by the state stream of [RxFormFieldBuilder<T>] '
        'should be of type [RxFieldException<T>] where T is the same T passed '
        'to [RxFormFieldBuilder<T>].',
      );

      if (exception is RxFieldException<T>) {
        setState(() {
          _value = exception.fieldValue;
          _error = exception.error;
        });
      }
    }).addTo(_compositeSubscription);

    _showErrorState.listen((event) {
      setState(() {
        _showError = event;
      });
    }).addTo(_compositeSubscription);
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _builder(this);
}
