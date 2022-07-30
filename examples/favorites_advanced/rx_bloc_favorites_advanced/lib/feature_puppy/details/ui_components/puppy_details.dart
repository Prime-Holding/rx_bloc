import 'dart:io';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../blocs/puppy_details_bloc.dart';
import 'puppy_details_app_bar.dart';

class PuppyDetails extends StatelessWidget {
  const PuppyDetails({
    required this.puppy,
    Key? key,
  }) : super(key: key);

  final Puppy puppy;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        bottom: false,
        key: const ValueKey(Keys.puppyDetailsPage),
        child: Stack(
          children: [
            RxBlocBuilder<PuppyDetailsBlocType, String>(
              state: (bloc) => bloc.states.imagePath,
              builder: (context, snapshot, bloc) => Hero(
                tag: '$PuppyCardAnimationTag ${puppy.id}',
                child: _buildPuppyBackgroundImage(snapshot.data ?? puppy.asset),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 10),
                  RxBlocBuilder<PuppyDetailsBlocType, String>(
                      state: (bloc) => bloc.states.name,
                      builder: (context, snapshot, bloc) => Text(
                            snapshot.data ?? puppy.name,
                            style: TextStyles.titleTextStyle,
                          )),
                  const SizedBox(height: 5),
                  RxBlocBuilder<PuppyDetailsBlocType, String>(
                      state: (bloc) => bloc.states.genderAndBreed,
                      builder: (context, snapshot, bloc) => Text(
                            snapshot.data ??
                                '${puppy.genderAsString}, '
                                    '${puppy.breedTypeAsString}',
                            style: TextStyles.subtitleTextStyle,
                          )),
                  const SizedBox(
                    height: 24,
                  ),
                  RxBlocBuilder<PuppyDetailsBlocType, String?>(
                    state: (bloc) => bloc.states.characteristics,
                    builder: (context, snapshot, bloc) => Text(
                      snapshot.data ?? puppy.displayCharacteristics!,
                      style: TextStyles.subtitleTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              child: RxBlocBuilder<PuppyDetailsBlocType, Puppy>(
                state: (bloc) => bloc.states.puppy,
                builder: (context, snapshot, bloc) => PuppyDetailsAppBar(
                  puppy: snapshot.data ?? puppy,
                ),
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
