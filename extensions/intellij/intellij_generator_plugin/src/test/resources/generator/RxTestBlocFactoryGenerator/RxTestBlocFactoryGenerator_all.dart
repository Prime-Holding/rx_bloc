import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';


import '../mock/sample_mock.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';


/// Change the parameters according the the needs of the test
Widget sampleFactory({
  String? state1,
  String? stateNullable1,
  Result<String>? stateResult2,
  List<CustomType>? stateListOfCustomType,
  PaginatedList<CustomType2>? statePaginatedResult3,
  bool? connectableState,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        RxBlocProvider<SampleBlocType>.value(
          value: sampleMockFactory(
            state1: state1,
            stateNullable1: stateNullable1,
            stateResult2: stateResult2,
            stateListOfCustomType: stateListOfCustomType,
            statePaginatedResult3: statePaginatedResult3,
            connectableState: connectableState,

          ),
        ),
      ], child: const SamplePage()),
    );