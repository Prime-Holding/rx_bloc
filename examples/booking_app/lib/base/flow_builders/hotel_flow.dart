import 'package:favorites_advanced_base/models.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/feature_hotel/details/views/hotel_details_page.dart';

class HotelFlowState {
  HotelFlowState({
    required this.hotel,
  });

  final Hotel hotel;

  HotelFlowState copyWith({
    Hotel? hotel,
    bool? manage,
  }) =>
      HotelFlowState(
        hotel: hotel ?? this.hotel,
      );
}

List<Page> onGenerateHotelPages(HotelFlowState state, List<Page> pages) => [
      HotelDetailsPage.page(hotel: state.hotel),
    ];

class HotelFlow extends StatelessWidget {
  const HotelFlow({
    required this.hotel,
    Key? key,
  }) : super(key: key);

  static Route<HotelFlowState> route({required Hotel hotel}) =>
      MaterialPageRoute(builder: (_) => HotelFlow(hotel: hotel));

  final Hotel hotel;

  @override
  Widget build(BuildContext context) => FlowBuilder(
        state: HotelFlowState(
          hotel: hotel,
        ),
        onGeneratePages: onGenerateHotelPages,
      );
}
