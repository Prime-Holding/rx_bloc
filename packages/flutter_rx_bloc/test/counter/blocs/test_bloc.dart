import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'test_bloc.rxb.g.dart';

abstract class TestBlocEvents {
  void setLoading(bool isLoading, {String tag = ''});
}

abstract class TestBlocStates {
  Stream<LoadingWithTag> get isLoadingWithTag;
}

@RxBloc()
class TestBloc extends $TestBloc {
  @override
  Stream<LoadingWithTag> _mapToIsLoadingWithTagState() =>
      _$setLoadingEvent.map((args) => LoadingWithTag(
            loading: args.isLoading,
            tag: args.tag,
          ));
}
