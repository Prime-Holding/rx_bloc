import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/models/errors/error_model.dart';
import '../services/analytics_service.dart';

part 'analytics_bloc.rxb.g.dart';

/// A contract class containing all events of the FirebaseBloc.
abstract class AnalyticsBlocEvents {}

/// A contract class containing all states of the FirebaseBloc.
abstract class AnalyticsBlocStates {}

@RxBloc()
class AnalyticsBloc extends $AnalyticsBloc {
  AnalyticsBloc(
    CoordinatorBlocType coordinator,
    AnalyticsService service,
  ) {
    coordinator.states.errorLogEvent.listen(
      (event) {
        service.recordError(
          event.error,
          StackTrace.fromString(
              '#0     ${_getMethodName(event.error)} (${_getFileName(event.error)}:1:1)'),
          event.errorLogDetails,
        );
      },
    ).addTo(_compositeSubscription);
  }

  String _getFileName(ErrorModel error) =>
      '${error.runtimeType.toString()}.dart';

  String _getMethodName(ErrorModel model) {
    return 'businessError';
  }
}
