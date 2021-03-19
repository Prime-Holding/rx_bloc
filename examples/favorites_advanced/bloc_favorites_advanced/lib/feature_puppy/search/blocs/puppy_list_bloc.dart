import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:meta/meta.dart';

part 'puppy_list_event.dart';

part 'puppy_list_state.dart';

part 'puppy_list_bloc_models.dart';

class PuppyListBloc extends Bloc<PuppyListEvent, PuppyListState> {
  PuppyListBloc(PuppiesRepository repository)
      : super(PuppyListState(
          searchedPuppies: _initialPuppies,
        )) {
    _fetchPuppies(repository);
  }

  void _fetchPuppies(PuppiesRepository repository) async {
    puppyItems = await repository.getPuppies(query: '');
    _initialPuppies = puppyItems;
  }

  static List<Puppy> _initialPuppies = [];
  List<Puppy> puppyItems = [];

  @override
  Stream<PuppyListState> mapEventToState(
    PuppyListEvent event,
  ) async* {
    yield PuppyListState(searchedPuppies: puppyItems);
  }
}
