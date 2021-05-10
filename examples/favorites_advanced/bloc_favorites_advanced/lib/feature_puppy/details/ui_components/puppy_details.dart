import 'dart:io';

import 'package:bloc_sample/feature_puppy/details/blocs/puppy_details_bloc.dart';
import 'package:bloc_sample/feature_puppy/details/ui_components/puppy_details_app_bar.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        child: BlocProvider(
          create: (context) => PuppyDetailsBloc(
            coordinatorBloc: context.read(),
            puppy: puppy,
          ),
          //   child: BlocProvider.value(
          //     value: BlocProvider.of<PuppyDetailsBloc>(context),
          child: Stack(
            children: [
              // BlocProvider(
              //   create: (context) => PuppyDetailsBloc(
              //     coordinatorBloc: context.read(),
              //     puppy: puppy,
              //   ),
              BlocBuilder<PuppyDetailsBloc, PuppyDetailsState>(
                builder: (context, state) => Hero(
                  tag: '$PuppyCardAnimationTag ${puppy.id}',
                  child: _buildPuppyBackgroundImage(
                      state.imagePath ?? puppy.asset),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 10),
                    BlocBuilder<PuppyDetailsBloc, PuppyDetailsState>(
                        builder: (context, state) => Text(
                              state.puppy?.name ?? puppy.name,
                              style: TextStyles.titleTextStyle,
                            )),
                    const SizedBox(height: 5),
                    BlocBuilder<PuppyDetailsBloc, PuppyDetailsState>(
                        builder: (context, state) => Text(
                              '${puppy.genderAsString}, '
                              '${puppy.breedTypeAsString}',
                              style: TextStyles.subtitleTextStyle,
                            )),
                    const SizedBox(
                      height: 24,
                    ),
                    BlocBuilder<PuppyDetailsBloc, PuppyDetailsState>(
                      builder: (context, state) => Text(
                        state.characteristics ?? puppy.displayCharacteristics!,
                        style: TextStyles.subtitleTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                child: BlocBuilder<PuppyDetailsBloc, PuppyDetailsState>(
                  builder: (context, state) {
                    if(state.puppy != null) {
                      print('puppy details: state state.puppy.isFavorite: ${
                          state.puppy!.isFavorite}');
                    }
                    // print('puppy details: state state.puppy.isFavorite: ${
                    //     state.isFavourite}');
                    return PuppyDetailsAppBar(
                      puppy: state.puppy ?? puppy,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // ),
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
