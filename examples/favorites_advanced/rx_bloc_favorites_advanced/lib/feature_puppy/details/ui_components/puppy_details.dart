import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/keys.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/text_styles.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/details/ui_components/puppy_details_app_bar.dart';

class PuppyDetails extends StatelessWidget {
  const PuppyDetails({@required this.puppy, Key key}) : super(key: key);

  final Puppy puppy;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        bottom: false,
        key: const ValueKey(Keys.puppyDetailsPage),
        child: Stack(
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
        ),
      );
}
