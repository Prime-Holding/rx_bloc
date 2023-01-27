import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

import '../../../base/ui_components/sorting_bar.dart';
import '../../base/common_blocs/hotel_manage_bloc.dart';
import '../../base/common_blocs/hotels_extra_details_bloc.dart';
import '../../feature_hotel_details/views/hotel_details_page.dart';
import '../blocs/hotel_search_bloc.dart';
import '../models/capacity_filter_data.dart';
import '../models/date_range_filter_data.dart';
import '../ui_components/hotel_capacity_page.dart';
import '../ui_components/hotel_sort_page.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({Key? key}) : super(key: key);

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage>
    with TickerProviderStateMixin {
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
                    RxTextFormFieldBuilder<HotelSearchBlocType>(
                      state: (bloc) => bloc.states.queryFilter,
                      showErrorState: (_) => const Stream.empty(),
                      builder: (fieldState) => SearchBar(
                        controller: fieldState.controller,
                      ),
                      onChanged: (bloc, text) {
                        bloc.events.filterByQuery(text);
                      },
                    ),
                    _buildFilters(context),
                  ],
                ),
                childCount: 1,
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: SortingBar(
                onPressed: (bloc, sortBy) async {
                  await Alert(
                    context: context,
                    title: 'Sort hotels by',
                    buttons: [],
                    onWillPopActive: true,
                    alertAnimation:
                        (context, animation, secondaryAnimation, child) =>
                            alertAnimation(animation, child),
                    content: HotelSortPage(
                      initialSelection: sortBy,
                      onApplyPressed: (sortBy) =>
                          bloc.events.sortBy(sort: sortBy),
                    ),
                  ).show();
                },
              ),
            ),
          ],
          body: Container(
            color: HotelAppTheme.buildLightTheme().colorScheme.background,
            child: RxPaginatedBuilder<HotelSearchBlocType,
                Hotel>.withRefreshIndicator(
              onBottomScrolled: (bloc) => bloc.events.reload(reset: false),
              onRefresh: (bloc) {
                bloc.events.reload(reset: true);
                return bloc.states.refreshDone;
              },
              state: (bloc) => bloc.states.hotels,
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

  /// region Builders

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

    return AnimatedListItem(
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

  Widget _buildFilters(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDateRangeFilter(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: 1,
                height: 42,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
            _buildCapacityFilter(),
          ],
        ),
      );

  Widget _buildDateRangeFilter() => Expanded(
        child: RxBlocBuilder<HotelSearchBlocType, DateRangeFilterData>(
          state: (bloc) => bloc.states.dateRangeFilterData,
          builder: (context, dateRangeFilterDataState, bloc) {
            final dateRangeText = dateRangeFilterDataState.data?.text ?? 'None';
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FocusButton(
                  onPressed: () async {
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Choose date',
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color: Colors.grey.withOpacity(0.8)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        dateRangeText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (dateRangeText != 'None')
                  _buildClearButton(() {
                    showYesNoMessage(
                      context: context,
                      title: 'Clear date range?',
                      onYesPressed: () {
                        bloc.events.filterByDateRange(dateRange: null);
                      },
                    );
                  }),
              ],
            );
          },
        ),
      );

  Widget _buildCapacityFilter() => Expanded(
        child: RxBlocBuilder<HotelSearchBlocType, CapacityFilterData>(
          state: (bloc) => bloc.states.capacityFilterData,
          builder: (context, capacityFilterDataState, bloc) {
            final capacityData = capacityFilterDataState.data;
            final capacityFilterText = capacityData?.text ?? 'None';
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FocusButton(
                  onPressed: () {
                    Alert(
                      context: context,
                      title: '',
                      buttons: [],
                      onWillPopActive: true,
                      alertAnimation:
                          (context, animation, secondaryAnimation, child) =>
                              alertAnimation(animation, child),
                      content: HotelCapacityPage(
                        roomCapacity: capacityData?.rooms ?? 0,
                        personCapacity: capacityData?.persons ?? 0,
                        onApplyPressed: (rooms, persons) {
                          bloc.events.filterByCapacity(
                            roomCapacity: rooms,
                            personCapacity: persons,
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ).show();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Capacity filters',
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color: Colors.grey.withOpacity(0.8)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        capacityFilterText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (capacityFilterText != 'None')
                  _buildClearButton(() {
                    showYesNoMessage(
                      context: context,
                      title: 'Clear capacity filter?',
                      onYesPressed: () {
                        bloc.events.filterByCapacity(
                          roomCapacity: 0,
                          personCapacity: 0,
                        );
                      },
                    );
                  }),
              ],
            );
          },
        ),
      );

  Widget _buildClearButton(VoidCallback? onPressed) => FocusButton(
        onPressed: onPressed ?? () {},
        child: const Icon(Icons.cancel, color: Colors.blue),
      );

  ///endregion
}
