import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/keys.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/text_styles.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppies_extra_details_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/details/blocs/puppy_manage_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy_details/ui_components/puppy_details_app_bar.dart';

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
        providers: _getProviders(),
        child: this,
      );

  @override
  Widget build(BuildContext context) =>
      RxResultBuilder<PuppyListBlocType, List<Puppy>>(
        state: (bloc) => bloc.states.searchedPuppies,
        buildLoading: (ctx, bloc) => _buildScaffoldBody(ctx, _puppy),
        buildError: (ctx, error, bloc) {
          Future.delayed(
            const Duration(microseconds: 10),
            () => bloc.events.reloadFavoritePuppies(silently: false),
          );
          return _buildScaffoldBody(context, _puppy);
        },
        buildSuccess: (ctx, puppyList, _) {
          final foundPuppy = ((puppyList?.isNotEmpty ?? false)
                  ? puppyList?.firstWhere((element) => element.id == _puppy.id)
                  : null) ??
              _puppy;
          return _buildScaffoldBody(context, foundPuppy);
        },
      );

  Widget _buildScaffoldBody(BuildContext context, Puppy puppy) => Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          key: const ValueKey(Keys.puppyDetailsPage),
          child: _buildBody(puppy),
        ),
      );

  Widget _buildBody(Puppy puppy) => Stack(
        children: [
          Hero(
            tag: '$PuppyCardAnimationTag ${puppy.id}',
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(puppy.asset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 10),
                Text(
                  puppy.name,
                  style: TextStyles.titleTextStyle,
                ),
                const SizedBox(height: 5),
                Text(
                  '${puppy.genderAsString}, ${puppy.breedTypeAsString}',
                  style: TextStyles.subtitleTextStyle,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  puppy.breedCharacteristics,
                  style: TextStyles.subtitleTextStyle,
                ),
              ],
            ),
          ),
          Positioned(
            child: PuppyDetailsAppBar(
              puppy: puppy,
            ),
          ),
        ],
      );
}
