part of 'dashboard_bloc.dart';

/// TODO: Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.
extension _DashboardExtension on DashboardBloc {}

extension _ToError on Stream<Exception> {
  /// TODO: Implement error event-to-state logic
  Stream<String> toMessage() => map((errorState) => errorState.toString());
}

extension _DashboardList on Stream<List<ReminderModel>> {
  Stream<ReminderModel?> _dashboardUpdatedReminder(_dashboardModelResult) =>
      withLatestFrom(
          _dashboardModelResult,
          (List<ReminderModel> updatedList, Result<DashboardModel> oldList) =>
              _UpdatedAndOldList(
                  updatedList: updatedList,
                  oldList: oldList)).switchMap((event) {
        final _updatedList = event.updatedList;
        final _oldList =
            (event.oldList as ResultSuccess<DashboardModel>).data.reminderList;
        ReminderModel? result;
        if (_oldList.length > _updatedList.length) {
          result =
              _setInResultAReminderFromOldList(_oldList, _updatedList, result);
        } else if (_oldList.length < _updatedList.length) {
          result = _setInResultAReminderFromUpdatedList(
              _updatedList, _oldList, result);
        }
        return Stream.value(result);
      });
}

ReminderModel? _setInResultAReminderFromUpdatedList(
    List<ReminderModel> _updatedList,
    List<ReminderModel> _oldList,
    ReminderModel? result) {
  for (var i = 0; i < _updatedList.length; i++) {
    var updated = _updatedList[i];
    if (i == _oldList.length) {
      result = _updatedList[_updatedList.length - 1].copyWith(isRemoved: false);
      break;
    }
    var old = _oldList[i];
    if (old.id != updated.id) {
      result = old.copyWith(isRemoved: false);
      break;
    }
  }
  return result;
}

ReminderModel? _setInResultAReminderFromOldList(List<ReminderModel> _oldList,
    List<ReminderModel> _updatedList, ReminderModel? result) {
  for (var i = 0; i < _oldList.length; i++) {
    var old = _oldList[i];
    if (i == _updatedList.length) {
      result = _oldList[_oldList.length - 1].copyWith(isRemoved: true);
      break;
    }
    if (old.id != _updatedList[i].id) {
      result = old.copyWith(isRemoved: true);
      break;
    }
  }
  return result;
}

class _UpdatedAndOldList {
  _UpdatedAndOldList({
    required this.updatedList,
    required this.oldList,
  });

  final List<ReminderModel> updatedList;
  final Result<DashboardModel> oldList;
}
