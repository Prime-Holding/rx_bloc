import 'dart:io';
import 'package:flutter/material.dart';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';

import '../../details/views/puppy_details_view_model.dart';
import 'puppy_details_app_bar.dart';

class PuppyDetails extends StatelessWidget {
  const PuppyDetails({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final PuppyDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        bottom: false,
        key: const ValueKey(Keys.puppyDetailsPage),
        child: Stack(
          children: [
            Hero(
              tag: '$PuppyCardAnimationTag ${viewModel.puppy.id}',
              child: _buildPuppyBackgroundImage(viewModel.puppy.asset),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    viewModel.puppy.name,
                    style: TextStyles.titleTextStyle,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${viewModel.puppy.genderAsString}, '
                    '${viewModel.puppy.breedTypeAsString}',
                    style: TextStyles.subtitleTextStyle,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    viewModel.puppy.displayCharacteristics!,
                    style: TextStyles.subtitleTextStyle,
                  ),
                ],
              ),
            ),
            Positioned(
              child: PuppyDetailsAppBar(
                puppy: viewModel.puppy,
                viewModel: viewModel,
              ),
            ),
          ],
        ),
      );

  Widget _buildPuppyBackgroundImage(String path) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: (path.contains('assets/puppie_')
                ? AssetImage(path)
                : FileImage(File(path))) as ImageProvider<Object>,
            fit: BoxFit.cover,
          ),
        ),
      );
}
