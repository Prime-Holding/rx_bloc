import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../feature_hotel/blocs/hotel_manage_bloc.dart';

class FavoriteMessageListener extends StatelessWidget {
  const FavoriteMessageListener({
    Key? key,
    this.overrideMargins = false,
  }) : super(key: key);

  final bool overrideMargins;

  @override
  Widget build(BuildContext context) =>
      RxBlocListener<HotelManageBlocType, String>(
        state: (bloc) => bloc.states.favoriteMessage,
        listener: (context, message) {
          if (message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                behavior: SnackBarBehavior.floating,
                margin: overrideMargins
                    ? const EdgeInsets.only(bottom: 70, left: 12, right: 12)
                    : null,
              ),
            );
          }
        },
      );
}
