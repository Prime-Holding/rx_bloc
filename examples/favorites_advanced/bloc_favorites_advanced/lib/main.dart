import 'package:auto_route/auto_route.dart';
import 'package:bloc_sample/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base/resources/color_styles.dart';
import 'base/routers/router.gr.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBarBloc>(
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
