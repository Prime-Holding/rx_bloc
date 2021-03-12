import 'package:auto_route/auto_route.dart';
import 'package:bloc_sample/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'base/resources/color_styles.dart';
import 'base/routers/router.gr.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<PuppiesRepository>(
              create: (context) => PuppiesRepository(ImagePicker())),
          Provider<NavigationBarBloc>(
            create: (context) => NavigationBarBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'Puppies app',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: ColorStyles.scaffoldBackgroundColor,
          ),
          builder: ExtendedNavigator<MyRouter>(
            router: MyRouter(),
          ),
        ),
      );
}
