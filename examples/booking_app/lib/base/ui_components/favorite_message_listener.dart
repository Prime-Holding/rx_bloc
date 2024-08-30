import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../common_blocs/hotel_manage_bloc.dart';

class FavoriteMessageListener extends StatelessWidget {
  const FavoriteMessageListener({
    this.overrideMargins = false,
    super.key,
  });

  final bool overrideMargins;

  @override
  Widget build(BuildContext context) =>
      RxBlocListener<HotelManageBlocType, String>(
        state: (bloc) => bloc.states.favoriteMessage,
        listener: (context, message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
              margin: overrideMargins
                  ? const EdgeInsets.only(bottom: 70, left: 12, right: 12)
                  : null,
            ),
          );
        },
      );
}
