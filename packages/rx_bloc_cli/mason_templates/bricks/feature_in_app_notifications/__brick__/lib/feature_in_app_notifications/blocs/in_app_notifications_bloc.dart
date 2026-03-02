import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/app/config/app_constants.dart';
import '../models/in_app_notification_model.dart';
import '../models/in_app_notifications_response_model.dart';
import '../services/in_app_notifications_service.dart';

part 'in_app_notifications_bloc.rxb.g.dart';

/// A contract class containing all events of the InAppNotificationsBloC.
abstract class InAppNotificationsBlocEvents {
  /// Loads in-app notifications with the ability to reset the pagination
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void loadNotifications({bool reset = false});

  /// Toggles the unread filter
  void toggleUnreadFilter();

  /// Marks an in-app notification as read
  void markAsRead(String id);
}

/// A contract class containing all states of the InAppNotificationsBloC.
abstract class InAppNotificationsBlocStates {
  /// The paginated list of in-app notifications
  Stream<PaginatedList<InAppNotificationModel>> get notifications;

  /// The state indicating whether the notifications are filtered by unread
  @RxBlocIgnoreState()
  Stream<bool> get isFilteredByUnread;

  /// The count of unread in-app notifications
  @RxBlocIgnoreState()
  Stream<int> get unreadCount;
}

/// A bloc for fetching and managing in-app notifications
@RxBloc()
class InAppNotificationsBloc extends $InAppNotificationsBloc {
  InAppNotificationsBloc(this._service) {
    _$markAsReadEvent
        .switchMap((id) => _service.markAsRead(id).asResultStream())
        .setResultStateHandler(this)
        .whereSuccess()
        .listen((_) => loadNotifications(reset: true))
        .addTo(_compositeSubscription);
  }

  static const _pageSize = 10;
  final InAppNotificationsService _service;
  final _paginatedListSubject =
      BehaviorSubject<PaginatedList<InAppNotificationModel>>.seeded(
    PaginatedList(list: [], pageSize: _pageSize),
  );
  final _unreadCountSubject = BehaviorSubject<int>.seeded(0);
  final _showUnreadOnlySubject = BehaviorSubject<bool>.seeded(false);

  @override
  Stream<PaginatedList<InAppNotificationModel>> _mapToNotificationsState() =>
      _$loadNotificationsEvent
          .startWith(false)
          .throttleTime(kBackpressureDuration)
          .withLatestFrom(_showUnreadOnlySubject,
              (reset, showUnreadOnly) => (reset, showUnreadOnly))
          .switchMap((args) {
            if (args.$1) {
              _paginatedListSubject.value.reset();
            }
            return _service
                .getNotifications(
                  page: _paginatedListSubject.value.pageToLoad,
                  pageSize: _pageSize,
                  unreadOnly: args.$2,
                )
                .then(_toPaginatedList)
                .asResultStream();
          })
          .setResultStateHandler(this)
          .mergeWithPaginatedList(_paginatedListSubject)
          .doOnData(_paginatedListSubject.add)
          .shareReplay(maxSize: 1);

  PaginatedList<InAppNotificationModel> _toPaginatedList(
    InAppNotificationsResponseModel response,
  ) {
    _unreadCountSubject.add(response.unreadCount);
    return PaginatedList(
      list: response.notifications,
      pageSize: _pageSize,
      totalCount: response.totalCount,
    );
  }

  @override
  Stream<bool> get isFilteredByUnread => _$toggleUnreadFilterEvent
      .withLatestFrom(
          _showUnreadOnlySubject, (_, showUnreadOnly) => !showUnreadOnly)
      .doOnData((showUnreadOnly) {
        _showUnreadOnlySubject.add(showUnreadOnly);
        loadNotifications(reset: true);
      })
      .startWith(_showUnreadOnlySubject.value)
      .shareReplay(maxSize: 1);

  @override
  Stream<int> get unreadCount => _unreadCountSubject;

  @override
  void dispose() {
    _paginatedListSubject.close();
    _unreadCountSubject.close();
    _showUnreadOnlySubject.close();
    super.dispose();
  }
}
