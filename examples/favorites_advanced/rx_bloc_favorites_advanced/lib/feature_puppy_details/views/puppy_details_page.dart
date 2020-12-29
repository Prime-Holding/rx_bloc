import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
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
              () => RxBlocProvider.of<PuppyListBlocType>(ctx)
                  .events
                  .reloadFavoritePuppies(silently: false));
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
        appBar: PuppyDetailsAppBar(
          puppy: puppy,
        ),
        body: SafeArea(
          key: const ValueKey('PuppyDetailsPage'),
          child: _buildBody(puppy),
        ),
      );

  Widget _buildBody(Puppy puppy) => Container(
        padding: const EdgeInsets.only(top: 10, left: 27, right: 27),
        child: Column(
          children: [
            Hero(
              tag: '$PuppyCardAnimationTag ${puppy.id}',
              child: PuppyAvatar(asset: puppy.asset),
            ),
            const SizedBox(height: 10),
            Text(
              puppy.name,
              style: TextStyles.titleTextStyle,
            ),
            _buildCategory('Breed', puppy.breedTypeAsString),
            _buildCategory('Gender', puppy.genderAsString),
            _buildCategory(
                'Characteristics', puppy.breedCharacteristics, false),
          ],
        ),
      );

  Widget _buildCategory(String categoryName, String categoryDescription,
          [bool inline = true]) =>
      inline
          ? Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '$categoryName : ',
                        style: TextStyles.title2TextStyle,
                        children: [
                          TextSpan(
                            text: categoryDescription,
                            style: TextStyles.subtitleTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  '$categoryName :',
                  style: TextStyles.title2TextStyle,
                ),
                const SizedBox(height: 7),
                Text(
                  categoryDescription,
                  style: TextStyles.subtitleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            );
}
