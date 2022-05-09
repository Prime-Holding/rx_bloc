part of 'dashboard_bloc.dart';

/// TODO: Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.
extension _DashboardExtension on DashboardBloc {}

extension _ToError on Stream<Exception> {
  /// TODO: Implement error event-to-state logic
  Stream<String> toMessage() => map((errorState) => errorState.toString());
}

extension ResultStreamExtensions on Stream<Result<DashboardModel>> {
  Future<void> waitToLoad() async {
    await Future.delayed(const Duration(milliseconds: 2000));
  }
}
