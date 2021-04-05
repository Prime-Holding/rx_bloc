import 'package:booking_app/base/ui_components/filter_bar.dart';
import 'package:booking_app/feature_hotel/details/views/hotel_details_page.dart';
import 'package:booking_app/feature_hotel/search/ui_components/advanced_filter_page.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
                      state: (bloc) => bloc.states.queryFilter,
                      showErrorState: (_) => const Stream.empty(),
                      builder: (fieldState) => SearchBar(
                        controller: fieldState.controller,
                      ),
                      onChanged: (bloc, text) {
                        bloc.events.filterByQuery(text);
                      },
                    ),
                    _buildFilterBuilders(
                      builder: (context, bloc, filterData) => FiltersBar(
                        dateRangeText: filterData.dateRangeText,
                        dateRangeFilterClearEnabled:
                            filterData.dateRangeText != 'None',
                        onDateRangeFilterClearPressed: () =>
                            _presentYesNoDialog(
                          context: context,
                          title: 'Clear date range?',
                          onYesPressed: () {
                            bloc.events.filterByDateRange(dateRange: null);
                          },
                        ),
                        advancedFiltersText: filterData.advancedFiltersText,
                        advancedFilerClearEnabled:
                            filterData.advancedFiltersText != 'None',
                        onAdvancedFilterClearPressed: () => _presentYesNoDialog(
                          context: context,
                          title: 'Clear advanced filters?',
                          onYesPressed: () {
                            bloc.events.filterByAdvanced(
                              roomCapacity: 0,
                              personCapacity: 0,
                            );
                          },
                        ),
                        onDatePressed: () async {
                          final pickedRange = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1, 12, 31),
                            saveText: 'Apply',
                          );
                          if (pickedRange == null) return;
                          bloc.events.filterByDateRange(
                            dateRange: pickedRange,
                          );
                        },
                        onHotelDetailsPressed: () {
                          Alert(
                            context: context,
                            title: '',
                            buttons: [],
                            onWillPopActive: true,
                            content: AdvancedFilterPage(
                              roomCapacity: filterData.rooms,
                              personCapacity: filterData.persons,
                              onApplyPressed: (rooms, persons) {
                                bloc.events.filterByAdvanced(
                                  roomCapacity: rooms,
                                  personCapacity: persons,
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                          ).show();
                        },
                      ),
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

  Widget _buildFilterBuilders({
    required Widget Function(
            BuildContext, HotelListBlocType, _FilterBuilderArgs)
        builder,
  }) =>
      RxBlocBuilder<HotelListBlocType, int>(
        state: (bloc) => bloc.states.roomCapacityFilter,
        builder: (context, roomCapacityFilterState, _) =>
            RxBlocBuilder<HotelListBlocType, int>(
          state: (bloc) => bloc.states.personCapacityFilter,
          builder: (context, personCapacityFilterState, _) =>
              RxBlocBuilder<HotelListBlocType, DateTimeRange?>(
            state: (bloc) => bloc.states.dateRangeFilter,
            builder: (context, dateRangeFilterState, _) =>
                RxBlocBuilder<HotelListBlocType, String>(
              state: (bloc) => bloc.states.dateRangeFilterText,
              builder: (context, dateRangeFilterTextState, _) =>
                  RxBlocBuilder<HotelListBlocType, String>(
                state: (bloc) => bloc.states.advancedFilterText,
                builder: (context, advancedFilterTextState, bloc) => builder(
                    context,
                    bloc,
                    _FilterBuilderArgs(
                      dateRange: dateRangeFilterState.data,
                      rooms: roomCapacityFilterState.data ?? 0,
                      persons: personCapacityFilterState.data ?? 0,
                      dateRangeText: dateRangeFilterTextState.data ?? '',
                      advancedFiltersText: advancedFilterTextState.data ?? '',
                    )),
              ),
            ),
          ),
        ),
      );

  Future<void> _presentYesNoDialog({
    required BuildContext context,
    required String title,
    VoidCallback? onYesPressed,
  }) async {
    await Alert(
      context: context,
      onWillPopActive: true,
      title: title,
      buttons: [
        DialogButton(
          onPressed: () {
            onYesPressed?.call();
            Navigator.of(context).pop();
          },
          color: Colors.red,
          child: const Text(
            'Yes',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        DialogButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'No',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ).show();
  }
}

class _FilterBuilderArgs {
  _FilterBuilderArgs({
    required this.dateRange,
    required this.rooms,
    required this.persons,
    required this.dateRangeText,
    required this.advancedFiltersText,
  });

  final DateTimeRange? dateRange;
  final int rooms;
  final int persons;
  final String dateRangeText;
  final String advancedFiltersText;
}
