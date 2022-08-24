import 'package:flutter/material.dart';

class SimpleTextField extends StatefulWidget {
  const SimpleTextField({
    required this.onChanged,
    this.controller,
    this.text,
    this.errorText,
    this.errorMaxLines,
    Key? key,
  }) : super(key: key);

  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final Stream<String>? text;
  final String? errorText;
  final int? errorMaxLines;

  @override
  _SimpleTextFieldState createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  InputDecoration get _decoration => InputDecoration(
        enabledBorder: _border,
        focusedBorder: _border,
        errorMaxLines: widget.errorMaxLines,
        errorText: widget.errorText,
      );

  final _border = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
      width: 1,
    ),
  );

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: _controller!,
        decoration: _decoration,
        onChanged: widget.onChanged,
      );
}
