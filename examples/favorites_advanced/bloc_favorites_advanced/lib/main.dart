import 'package:bloc_sample/feature_home/views/home_page.dart';
import 'package:flutter/material.dart';

import 'package:favorites_advanced_base/resources.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>  MaterialApp(
          title: 'Puppies app',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: ColorStyles.scaffoldBackgroundColor,
          ),
          home: HomePage.page(),
        );
}
