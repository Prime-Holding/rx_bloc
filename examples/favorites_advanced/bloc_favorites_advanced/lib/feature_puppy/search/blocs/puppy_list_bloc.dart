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
  PuppyListBloc(this.repository)
      : super(const PuppyListState(status: PuppyListStatus.loading));

  PuppiesRepository repository;
  List<Puppy> puppyItems = [];

  Future<List<Puppy>> _fetchPuppies(PuppiesRepository repository) async {
    final puppies = await repository.getPuppies(query: '');
    if (puppies.isEmpty) {
      throw Exception('error fetching puppies');
    }
    return puppies;
  }

  @override
  Stream<PuppyListState> mapEventToState(
    PuppyListEvent event,
  ) async* {
    if (event is LoadPuppyListEvent) {
      yield await _mapPuppiesFetchedToState(state);
    } else if(event is ReloadFavoritePuppies){
      // if Reload
      yield await _mapPuppiesFetchedToState(state);
    }
  }

  Future<PuppyListState> _mapPuppiesFetchedToState(PuppyListState state) async {
    try {
      await Future.delayed( const Duration(seconds: 2));
      if (state.status == PuppyListStatus.loading) {
        // When puppies are loaded for the first time
        puppyItems = await _fetchPuppies(repository);
        return state.copyWith(
          searchedPuppies: puppyItems,
          status: PuppyListStatus.success,
        );
      }else if(state.status == PuppyListStatus.success){
        // When the puppies were loaded and then reloaded
        puppyItems = await _fetchPuppies(repository);
        return state.copyWith(
          searchedPuppies: puppyItems,
          status: PuppyListStatus.loading,
        );
      }
    } on Exception {
      return state.copyWith(status: PuppyListStatus.failure);
    }
  }
}
