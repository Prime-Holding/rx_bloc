import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:flutter_rx_bloc/src/rx_field_exception.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'rx_text_form_field_builder.dart';

typedef RxFormFieldState<B extends RxBlocTypeBase, T> = Stream<T> Function(B);

typedef RxFormFieldShowError<B extends RxBlocTypeBase> = Stream<bool> Function(
    B);

typedef RxFormFieldOnChanged<B extends RxBlocTypeBase, T> = void Function(B, T);

typedef RxFormFieldBuilderFunction<B extends RxBlocTypeBase, T>
    = Widget Function(
        RxFormFieldBuilderState<B, T, RxFormFieldBuilder<B, T>> fieldState);

class RxFormFieldBuilder<B extends RxBlocTypeBase, T> extends StatefulWidget {
  const RxFormFieldBuilder({
    @required this.state,
    @required this.showErrorState,
    @required this.builder,
    this.bloc,
    Key key,
  })  : assert(state != null),
        assert(showErrorState != null),
        assert(builder != null),
        super(key: key);

  final RxFormFieldState<B, T> state;
  final RxFormFieldShowError<B> showErrorState;
  final RxFormFieldBuilderFunction<B, T> builder;

  final B bloc;

  @override
  RxFormFieldBuilderState createState() =>
      RxFormFieldBuilderState<B, T, RxFormFieldBuilder<B, T>>();
}

class RxFormFieldBuilderState<B extends RxBlocTypeBase, T,
    R extends RxFormFieldBuilder<B, T>> extends State<R> {
  B _bloc;
  Stream<T> _blocState;
  Stream<bool> _showErrorState;

  T _value;
  String _error = '';
  bool _showError = false;

  RxFormFieldBuilderFunction<B, T> get _builder => widget.builder;

  final _compositeSubscription = CompositeSubscription();

  B get bloc => _bloc;

  T get value => _value;

  String get error => _error;

  bool get showError => _showError;

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
        exception is RxFieldException,
        'Actual: Exception is [${exception.runtimeType}], '
        '${exception.toString()} \n'
        'Exceptions thrown by the state stream '
        'should be of type [RxFieldException].',
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
        _showError = event ?? false;
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
