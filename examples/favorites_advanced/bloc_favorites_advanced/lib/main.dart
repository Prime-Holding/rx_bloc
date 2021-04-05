import 'package:bloc_sample/feature_home/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:favorites_advanced_base/core.dart';

import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<PuppiesRepository>(
              create: (context) => PuppiesRepository(
                    ImagePicker(),
                    ConnectivityRepository(),
                  )),
        ],
        child: MaterialApp(
          title: 'Puppies app',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: ColorStyles.scaffoldBackgroundColor,
          ),
          home: HomePage.page(),
        ),
      );
}
