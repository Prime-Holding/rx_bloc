part of 'hotel_details_page.dart';

List<RxBlocProvider> _getProviders(Hotel hotel) => [
      RxBlocProvider<HotelManageBlocType>(
        create: (context) => HotelManageBloc(
          Provider.of(context, listen: false),
          Provider.of(context, listen: false),
        ),
      ),
      RxBlocProvider<HotelsExtraDetailsBlocType>(
        create: (context) => HotelsExtraDetailsBloc(
          Provider.of(context, listen: false),
          Provider.of(context, listen: false),
        ),
      ),
      RxBlocProvider<HotelDetailsBlocType>(
        create: (context) => HotelDetailsBloc(
          Provider.of(context, listen: false),
          hotel: hotel,
        ),
      ),
    ];
