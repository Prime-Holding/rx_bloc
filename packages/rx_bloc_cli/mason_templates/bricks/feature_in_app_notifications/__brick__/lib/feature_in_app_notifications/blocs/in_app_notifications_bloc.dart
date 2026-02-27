import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/app/config/app_constants.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../models/in_app_notification_model.dart';
import '../models/in_app_notifications_response_model.dart';
import '../services/in_app_notifications_service.dart';

part 'in_app_notifications_bloc.rxb.g.dart';

/// A contract class containing all events of the InAppNotificationsBloC.
abstract class InAppNotificationsBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void loadNotifications({bool reset = false});

  void toggleUnreadFilter();

  void markAsRead(String id);
}

/// A contract class containing all states of the InAppNotificationsBloC.
abstract class InAppNotificationsBlocStates {
  Stream<bool> get isLoading;

  Stream<ErrorModel> get errors;

  Stream<PaginatedList<InAppNotificationModel>> get notifications;

  Stream<bool> get isFilteredByUnread;

  @RxBlocIgnoreState()
  Stream<int> get unreadCount;
}

@RxBloc()
class InAppNotificationsBloc extends $InAppNotificationsBloc {
  InAppNotificationsBloc(this._service) {
    loadNotifications();

    _$markAsReadEvent
        .switchMap((id) => _service.markAsRead(id).asResultStream())
        .setResultStateHandler(this)
        .whereSuccess()
        .listen((_) {
          if (_unreadCount.value > 0) {
            _unreadCount.add(_unreadCount.value - 1);
          }
          loadNotifications(reset: true);
        })
        .addTo(_compositeSubscription);
  }

  final InAppNotificationsService _service;

  static const _pageSize = 10;

  final _paginatedList =
      BehaviorSubject<PaginatedList<InAppNotificationModel>>.seeded(
    PaginatedList(list: [], pageSize: _pageSize),
  );

  final _unreadCount = BehaviorSubject<int>.seeded(0);

  bool _showUnreadOnly = false;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<PaginatedList<InAppNotificationModel>>
      _mapToNotificationsState() => _$loadNotificationsEvent
          .startWith(false)
          .throttleTime(kBackpressureDuration)
          .switchMap((reset) {
            if (reset) {
              _paginatedList.value.reset();
            }
            return _service
                .getNotifications(
                  page: _paginatedList.value.pageToLoad,
                  pageSize: _pageSize,
                  unreadOnly: _showUnreadOnly,
                )
                .then(_toPaginatedList)
                .asResultStream();
          })
          .setResultStateHandler(this)
          .mergeWithPaginatedList(_paginatedList)
          .doOnData(_paginatedList.add)
          .shareReplay(maxSize: 1);

  PaginatedList<InAppNotificationModel> _toPaginatedList(
    InAppNotificationsResponseModel response,
  ) {
    _unreadCount.add(response.unreadCount);
    return PaginatedList(
      list: response.notifications,
      pageSize: _pageSize,
      totalCount: response.totalCount,
    );
  }

  @override
  Stream<bool> _mapToIsFilteredByUnreadState() => _$toggleUnreadFilterEvent
      .map((_) {
        _showUnreadOnly = !_showUnreadOnly;
        loadNotifications(reset: true);
        return _showUnreadOnly;
      })
      .startWith(false)
      .shareReplay(maxSize: 1);

  @override
  Stream<int> get unreadCount => _unreadCount;

  @override
  void dispose() {
    _paginatedList.close();
    _unreadCount.close();
    super.dispose();
  }
  
  
}
