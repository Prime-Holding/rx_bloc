import 'package:auto_route/auto_route.dart';
import 'package:bloc_sample/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:favorites_advanced_base/resources.dart';
import 'package:image_picker/image_picker.dart';
import 'base/routers/router.gr.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          // BlocProvider<NavigationBarBloc>(
          //   create: (context) => NavigationBarBloc(),
          // ),
          BlocProvider<PuppyListBloc>(
            create: (context) => PuppyListBloc(
                PuppiesRepository(ImagePicker())),
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
