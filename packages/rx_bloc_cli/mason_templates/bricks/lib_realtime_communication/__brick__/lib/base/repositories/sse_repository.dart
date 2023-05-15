import 'package:rxdart/rxdart.dart';

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/sse_remote_data_source.dart';
import '../models/errors/error_model.dart';
import '../models/response_models/sse_message_model.dart';
import '../utils/retry_when_mixin.dart';

class SseRepository {
  SseRepository(this._dataSource, this._errorMapper);

  final SseRemoteDataSource _dataSource;
  final ErrorMapper _errorMapper;

  Stream<SseMessageModel> getEventStream() {
    final state = _SseRetryState();

    return Rx.retryWhen(
      () => _errorMapper.executeStream(
        _dataSource
            .getEventStream()
            .doOnData(state.resetAttempts)
            .concatWith([Stream.error(NetworkErrorModel())]),
      ),
      state.retry,
    );
  }
}

class _SseRetryState with RetryWhenMixin {
  @override
  final retryDelays = const [
    Duration(milliseconds: 500),
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
    Duration(seconds: 8),
    Duration(seconds: 8),
  ];

  @override
  int get maxRetryAttempts => 10;
}
