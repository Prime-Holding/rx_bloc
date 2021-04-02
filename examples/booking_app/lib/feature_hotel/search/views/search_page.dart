import 'package:booking_app/base/ui_components/filter_bar.dart';
import 'package:booking_app/feature_hotel/details/views/hotel_details_page.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

import '../../blocs/hotel_manage_bloc.dart';
import '../../blocs/hotels_extra_details_bloc.dart';
import '../blocs/hotel_list_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  late AnimationController animationController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Column(
                  children: <Widget>[
                    RxTextFormFieldBuilder<HotelListBlocType>(
                      state: (bloc) => bloc.states.query,
                      showErrorState: (_) => const Stream.empty(),
                      builder: (fieldState) => SearchBar(
                        controller: fieldState.controller,
                      ),
                      onChanged: (bloc, text) {
                        bloc.events.filterByQuery(text);
                      },
                    ),
                    RxBlocBuilder<HotelListBlocType, HotelSearchFilters>(
                      state: (bloc) => bloc.states.filters,
                      builder: (context, filterState, bloc) {
                        final filter = filterState.data;
                        final nowTime = DateTime.now();
                        return TimeDateBar(
                          startDate: filter?.dateRange?.start ?? nowTime,
                          endDate: filter?.dateRange?.end ??
                              nowTime.add(const Duration(days: 5)),
                          onDatePressed: () async {
                            final pickedRange = await showDateRangePicker(
                              context: context,
                              firstDate: nowTime,
                              lastDate: DateTime(nowTime.year + 1, 12, 31),
                            );
                            if (pickedRange == null) return;
                            bloc.events.filterByDateRange(pickedRange);
                          },
                          onHotelDetailsPressed: () {
                            debugPrint('Hotel details pressed!');
                          },
                        );
                      },
                    ),
                  ],
                ),
                childCount: 1,
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: FilterBar(),
            ),
          ],
          body: Container(
            color: HotelAppTheme.buildLightTheme().backgroundColor,
            child: RxPaginatedBuilder<HotelListBlocType,
                Hotel>.withRefreshIndicator(
              onBottomScrolled: (bloc) => bloc.events.reload(reset: false),
              onRefresh: (bloc) {
                bloc.events.filterByDateRange(null);
                bloc.events.reload(reset: true);
                return bloc.states.refreshDone;
              },
              state: (bloc) => bloc.states.searchedHotels,
              buildSuccess: (context, list, bloc) => ListView.builder(
                itemCount: list.itemCount,
                padding: const EdgeInsets.only(bottom: 100, top: 10),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) =>
                    _buildSuccess(context, list, index),
              ),
              buildLoading: (context, list, bloc) {
                animationController.reset();
                return LoadingWidget(
                  key: const Key('LoadingWidget'),
                  alignment: Alignment.topCenter,
                );
              },
              buildError: (context, list, bloc) => ErrorRetryWidget(
                onReloadTap: () => bloc.events.reload(
                  reset: true,
                  fullReset: true,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildSuccess(
    BuildContext context,
    PaginatedList<Hotel> list,
    int index,
  ) {
    final count = list.itemCount > 10 ? 10 : list.itemCount;

    final animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval((1 / count) * index, 1, curve: Curves.fastOutSlowIn),
      ),
    );

    animationController.forward();

    final item = list.getItem(index);

    if (item == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: LoadingWidget(),
      );
    }

    return RxAnimatedListItem(
      animationController: animationController,
      animation: animation,
      child: HotelListItem(
        hotel: item,
        onCardPressed: (index) => Navigator.of(context).push(
          HotelDetailsPage.route(hotel: item),
        ),
        onFavorite: (index, isFavorite) =>
            RxBlocProvider.of<HotelManageBlocType>(context)
                .events
                .markAsFavorite(hotel: item, isFavorite: isFavorite),
        onVisible: (index) =>
            RxBlocProvider.of<HotelsExtraDetailsBlocType>(context)
                .events
                .fetchExtraDetails(item),
      ),
    );
  }
}
