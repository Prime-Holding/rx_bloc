import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'favorite_puppies_event.dart';
part 'favorite_puppies_state.dart';

class FavoritePuppiesBloc extends Bloc<FavoritePuppiesEvent, FavoritePuppiesState> {
  FavoritePuppiesBloc() : super(FavoritePuppiesInitial());

  @override
  Stream<FavoritePuppiesState> mapEventToState(
    FavoritePuppiesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
