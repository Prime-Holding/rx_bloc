import 'package:bloc_sample/feature_puppy/blocs/puppy_manage_bloc.dart';
import 'package:bloc_sample/feature_puppy/details/blocs/puppy_details_bloc.dart';
import 'package:bloc_sample/feature_puppy/details/ui_components/puppy_details.dart';
import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:favorites_advanced_base/core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'puppy_details_providers.dart';

class PuppyDetailsPage extends StatelessWidget {
  const PuppyDetailsPage({
    required Puppy puppy,
    Key? key,
  })  : _puppy = puppy,
        super(key: key);

  static Page page({required Puppy puppy}) => MaterialPage(
        child: MultiBlocProvider(
          providers: _getProviders(puppy),
          child: PuppyDetailsPage(puppy: puppy),
        ),
      );

  final Puppy _puppy;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => FavoritePuppiesBloc(
                puppiesRepository: context.read(),
                coordinatorBloc: context.read(),
              ),
            ),
          ],
          child: PuppyDetails(
            puppy: _puppy,
          ),
        ),
      );
}
