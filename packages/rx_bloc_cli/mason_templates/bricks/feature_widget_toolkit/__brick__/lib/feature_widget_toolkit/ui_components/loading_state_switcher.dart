import 'package:flutter/widgets.dart';

class LoadingStateSwitcher extends StatefulWidget {
  const LoadingStateSwitcher({required this.builder, Key? key})
      : super(key: key);

  final Widget Function(bool isDataLoading, void Function(bool value)) builder;

  @override
  State<LoadingStateSwitcher> createState() => _LoadingStateSwitcherState();
}

class _LoadingStateSwitcherState extends State<LoadingStateSwitcher> {
  late bool isLoading;

  @override
  void initState() {
    _slapAfterThreeSeconds(true);
    super.initState();
  }

  Future<void> _slapAfterThreeSeconds(bool initial) async {
    if (mounted) {
      setState(() {
        isLoading = initial;
      });
    }
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        isLoading = !initial;
      });
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder.call(isLoading, _slapAfterThreeSeconds);
}
