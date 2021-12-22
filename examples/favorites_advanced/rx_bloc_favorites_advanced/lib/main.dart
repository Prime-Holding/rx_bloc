import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'base/common_blocs/coordinator_bloc.dart';
import 'base/repositories/paginated_puppies_repository.dart';
import 'feature_home/views/home_page.dart';
import 'feature_puppy/search/blocs/puppy_list_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<PaginatedPuppiesRepository>(
            create: (context) => PaginatedPuppiesRepository(
              PuppiesRepository(
                ImagePicker(),
                ConnectivityRepository(),
                multiplier: 10,
              ),
            ),
          ),
          Provider<CoordinatorBlocType>(create: (context) => CoordinatorBloc()),
          Provider<PuppyListBlocType>(
            create: (context) => PuppyListBloc(
              Provider.of(context, listen: false),
              Provider.of(context, listen: false),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Puppies app',
          home: HomePage.page(),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: ColorStyles.scaffoldBackgroundColor,
          ),
        ),
      );
}
