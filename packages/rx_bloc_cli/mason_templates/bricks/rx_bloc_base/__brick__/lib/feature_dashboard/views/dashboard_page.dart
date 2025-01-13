import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/dashboard_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(context.designSystem.icons.reload),
              onPressed: context.read<DashboardBlocType>().events.fetchData,
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RxBlocListener<DashboardBlocType, ErrorModel>(
              state: (bloc) => bloc.states.errors.translate(context),
              listener: (context, error) => _onError,
            ),
            Center(
              child: RxResultBuilder<DashboardBlocType, String>(
                state: (bloc) => bloc.states.data,
                buildLoading: (ctx, bloc) => const CircularProgressIndicator(),
                buildError: (ctx, error, bloc) => AppErrorWidget(
                  error: error,
                  onTabRetry: ctx.read<DashboardBlocType>().events.fetchData,
                ),
                buildSuccess: (ctx, text, bloc) => _DashboardSuccessWidget(
                  text: text,
                ),
              ),
            ),
          ],
        ),
      );

  void _onError(BuildContext context, String errorMessage) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
}

class _DashboardSuccessWidget extends StatefulWidget {
  final String text;

  const _DashboardSuccessWidget({
    required this.text,
  });

  @override
  _DashboardSuccessWidgetState createState() => _DashboardSuccessWidgetState();
}

class _DashboardSuccessWidgetState extends State<_DashboardSuccessWidget> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Schedule the animation to start after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() => _isVisible = true),
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: AnimatedSlide(
          offset: _isVisible ? Offset(0, 0) : Offset(0, -0.05),
          duration: Duration(milliseconds: 500),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: context.designSystem.spacing.m,
              horizontal: context.designSystem.spacing.l,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  context.designSystem.icons.dashboardOutlined,
                  size: context.designSystem.spacing.xxxxl3,
                ),
                SizedBox(height: context.designSystem.spacing.s),
                Text(
                  context.l10n.dashboard,
                  style: context.designSystem.typography.h1Med32,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.designSystem.spacing.xs),
                Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: context.designSystem.typography.h2Reg16,
                ),
              ],
            ),
          ),
        ),
      );
}
