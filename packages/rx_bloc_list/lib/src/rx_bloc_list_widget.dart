import 'package:flutter/material.dart';
import '../rx_bloc_list.dart';

typedef PaginationBuilder = Widget Function<T>(
  BuildContext context,
  int itemIndex,
  T item,
);

class RxBlocListView<B extends RxBlocListInterface, T> extends StatelessWidget {
  RxBlocListView({
    required this.bloc,
    required this.builder,
    required this.paginatedData,
    Key? key,
  }) : super(key: key);

  final B bloc;
  final PaginationBuilder builder;
  final List<T> paginatedData;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () => _onRefresh(),
        child: ListView.builder(
          itemBuilder: (context, index) => builder(
            context,
            index,
            paginatedData[index],
          ),
          itemCount: paginatedData.length,
        ),
      );

  /// endregion

  /// region Methods
  //
  Future _onRefresh() async {
    // onRefresh is called once the RefreshIndicator's animation reaches
    // its main spinning part. In order to stop that animation, we need to
    // return a future, after we're done with refreshing the data

    bloc.loadPage(reset: true);
    return bloc.refreshDone.waitToLoad();
  }
}

extension _StreamBoolExtensions on Stream<bool> {
  Future<void> waitToLoad() async {
    await this.firstWhere((e) => !e);
    await this.firstWhere((e) => e);
  }
}
