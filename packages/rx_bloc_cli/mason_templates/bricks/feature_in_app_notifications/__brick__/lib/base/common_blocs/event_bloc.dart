import 'dart:convert';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../app/config/app_constants.dart';
import '../common_services/sse_service.dart';
import '../extensions/error_model_extensions.dart';
import '../models/errors/error_model.dart';
import '../models/notification_event_model.dart';
import '../models/response_models/sse_message_model.dart';
import 'coordinator_bloc.dart';

part 'event_bloc.rxb.g.dart';
part 'event_bloc_extensions.dart';

/// A contract class containing all events of the EventBloC.
abstract class EventBlocEvents {
  /// Event to start listening for SSE events
  void startListeningForSSE();

  /// Event to emit a notification event manually
  void receiveEvent(NotificationEvent event);
}

/// A contract class containing all states of the EventBloC.
abstract class EventBlocStates {
  /// State logging any errors that occur in the bloc
  Stream<ErrorModel> get errors;

  /// State emitting the notification events
  @RxBlocIgnoreState()
  Stream<NotificationEvent> get notificationEvents;
}

/// Bloc responsible for managing notifications
@RxBloc()
class EventBloc extends $EventBloc {
  EventBloc(this._sseService, this._coordinatorBloc){

    Rx.merge<NotificationEvent>([
      _$startListeningForSSEEvent.startWith(null).mergeWith([
        _coordinatorBloc.states.isAuthenticated
          .where((isAuthenticated) => isAuthenticated)
          .mapTo(null)
          .debounceTime(kBackpressureDuration),
      ])
        .switchMap((_) => 
          _sseService.getEventStream()
            .parseSseEvent(_coordinatorBloc)
            .whereType<NotificationEvent>()),
      _$receiveEventEvent,
    ]).bind(_notificationEventsSubject).addTo(_compositeSubscription);
  }

  final SseService _sseService;
  final CoordinatorBlocType _coordinatorBloc;
  final _notificationEventsSubject = BehaviorSubject<NotificationEvent>();

  @override
  Stream<NotificationEvent> get notificationEvents => _notificationEventsSubject;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  void dispose() {
    _notificationEventsSubject.close();
    super.dispose();
  }
}
