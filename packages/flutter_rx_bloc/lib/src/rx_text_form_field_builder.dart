part of 'rx_form_field_builder.dart';

typedef RxTextFormFieldBuilderFunction<B extends RxBlocTypeBase> = Widget
    Function(RxTextFormFieldBuilderState<B> fieldState);

class RxTextFormFieldBuilder<B extends RxBlocTypeBase>
    extends RxFormFieldBuilder<B, String> {
  RxTextFormFieldBuilder({
    @required RxFormFieldState<B, String> state,
    @required RxFormFieldShowError<B> showError,
    @required RxFormFieldOnChanged<B, String> onChanged,
    @required RxTextFormFieldBuilderFunction<B> builder,
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
  final RxTextFormFieldBuilderFunction<B> textFormBuilder;

  ///if one is not provided, an internal one is created
  final TextEditingController controller;

  final bool obscureText;

  final RxInputDecorationData decorationData;

  final B bloc;

  @override
  RxTextFormFieldBuilderState createState() => RxTextFormFieldBuilderState<B>();
}

class RxTextFormFieldBuilderState<B extends RxBlocTypeBase>
    extends RxFormFieldBuilderState<B, String, RxTextFormFieldBuilder<B>> {
  bool _shouldDisposeController;
  TextEditingController _controller;
  InputDecoration _decoration;
  bool _isTextObscured;

  bool get isTextObscured => _isTextObscured;
  TextEditingController get controller => _controller;
  InputDecoration get decoration => _decoration;

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
      _blocState.isBroadcast,
      'valueState passed to [RXTextFormFieldBuilder], '
      'should be a broadcast stream',
    );

    _blocState.listen(
      (value) {
        if (_controller.text != value) {
          _controller.text = value;
        }
      },
      onError: (error) {},
    ).addTo(_compositeSubscription);
  }

  @override
  void dispose() {
    if (_shouldDisposeController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO think about generating decoration only when necessary
    _decoration = _makeDecoration(showError, error);
    return widget.textFormBuilder(this);
  }

  InputDecoration _makeDecoration(bool showError, String error) =>
      InputDecoration(
        labelStyle: !showError && error != null
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
        errorText: showError ? error : null,
      );
}
