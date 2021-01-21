import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/src/rx_form_field_builder.dart';
import 'package:flutter_rx_bloc/src/rx_input_decoration_data.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

typedef RxTextFormFieldBuilderFunction = Widget Function(
    InputDecoration, TextEditingController);

class RxTextFormFieldBuilder<B extends RxBlocTypeBase>
    extends RxFormFieldBuilder<B, String> {
  RxTextFormFieldBuilder({
    @required RxFormFieldState<B, String> state,
    @required RxFormFieldShowError<B> showError,
    @required RxFormFieldOnChanged<B, String> onChanged,
    @required RxTextFormFieldBuilderFunction builder,
    this.decorationData = const RxInputDecorationData(),
    this.controller,
    this.obscureText = false,
    this.bloc,
    Key key,
  })  : assert(state != null),
        assert(showError != null),
        assert(onChanged != null),
        assert(builder != null),
        assert(obscureText != null),
        assert(decorationData != null),
        this.onChanged = onChanged,
        textFormBuilder = builder,
        super(
          key: key,
          state: state,
          showErrorState: showError,
          builder: (_) {},
        );

  final RxFormFieldOnChanged<B, String> onChanged;
  final RxTextFormFieldBuilderFunction textFormBuilder;

  ///if one is not provided, an internal one is created
  final TextEditingController controller;

  final bool obscureText;

  final RxInputDecorationData decorationData;

  final B bloc;

  @override
  _RxFormBuilderState createState() => _RxFormBuilderState<B>();
}

class _RxFormBuilderState<B extends RxBlocTypeBase>
    extends RxFormFieldBuilderState<B, String, RxTextFormFieldBuilder<B>> {
  // @override
  // RxTextFormFieldBuilder<B> get widget =>
  //     super.widget as RxTextFormFieldBuilder<B>;

  RxTextFormFieldBuilderFunction get _builder => widget.textFormBuilder;

  bool _shouldDisposeController;
  TextEditingController _controller;

  bool _isTextObscured;

  @override
  void initState() {
    super.initState();

    _shouldDisposeController = widget.controller != null ? false : true;
    _controller = widget.controller ?? TextEditingController();

    _isTextObscured = widget.obscureText;

    _controller.addListener(() {
      widget.onChanged(bloc, _controller.text);
    });

    assert(
      blocState.isBroadcast,
      'valueState passed to [RXTextFormFieldBuilder], '
      'should be a broadcast stream',
    );

    blocState.listen((value) {
      if (_controller.text != value) {
        _controller.text = value;
      }
    }).addTo(compositeSubscription);
  }

  @override
  void dispose() {
    if (_shouldDisposeController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO generate decoration only when neccessary
    final decoration = _decoration(showError, error);

    return _builder(decoration, _controller);
  }

  InputDecoration _decoration(bool showError, String error) => InputDecoration(
        // labelText: widget.decorationData?.label,
        labelStyle: !showError
            ? widget.decorationData?.labelStyle
            : widget.decorationData?.labelStyleError,
        suffixIcon: widget.obscureText
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isTextObscured = !_isTextObscured;
                  });
                },
                child: Padding(
                  child: _isTextObscured
                      ? widget.decorationData?.iconVisibility
                      : widget.decorationData?.iconVisibilityOff,
                  padding: const EdgeInsets.all(16),
                ),
              )
            : null,
        // prefixIcon: widget.decorationData?.prefixIcon != null
        //     ? Padding(
        //         child: widget.decorationData?.prefixIcon,
        //         padding: const EdgeInsets.all(16),
        //       )
        //     : null,
        // filled: true,
        // fillColor: widget.decorationData?.fillColor,
        errorText: showError ? error : null,
        // errorStyle: widget.decorationData?.errorStyle,
        // enabledBorder: UnderlineInputBorder(
        //   borderSide:
        //       BorderSide(color: widget.decorationData?.enabledBorderColor),
        // ),
        // focusedBorder: UnderlineInputBorder(
        //   borderSide:
        //       BorderSide(color: widget.decorationData?.focusedBorderColor),
        // ),
        // errorBorder: UnderlineInputBorder(
        //   borderSide:
        //       BorderSide(color: widget.decorationData?.errorBorderColor),
        // ),
        // focusedErrorBorder: UnderlineInputBorder(
        //   borderSide:
        //       BorderSide(color: widget.decorationData?.focusedErrorBorderColor),
        // ),
      );
}
