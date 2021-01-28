import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppies_extra_details_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppy_manage_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/details/blocs/puppy_details_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/details/ui_components/puppy_details.dart';

part 'puppy_details_providers.dart';

class PuppyDetailsPage extends StatelessWidget with AutoRouteWrapper {
  const PuppyDetailsPage({
    @required Puppy puppy,
    Key key,
  })  : _puppy = puppy,
        super(key: key);

  final Puppy _puppy;

  @override
  Widget wrappedRoute(BuildContext context) => RxMultiBlocProvider(
        providers: _getProviders(_puppy),
        child: this,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PuppyDetails(
          puppy: _puppy,
        ),
      );
}
