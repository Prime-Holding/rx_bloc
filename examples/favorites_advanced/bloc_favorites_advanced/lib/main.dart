import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'base/common_blocs/coordinator_bloc.dart';
import 'base/resources/color_styles.dart';
import 'base/routers/router.gr.dart';

void main() {
  runApp(MyApp());
}

// bloc_favorites_advanced/navigation first commit
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      Provider<PuppiesRepository>(
          create: (context) => PuppiesRepository(ImagePicker())),
      // Provider<CoordinatorBlocType>(create: (context) => CoordinatorBloc()),
      // Provider<PuppyListBlocType>(
      //   create: (context) => PuppyListBloc(
      //     Provider.of(context, listen: false),
      //     Provider.of(context, listen: false),
      //   ),
      // ),
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
