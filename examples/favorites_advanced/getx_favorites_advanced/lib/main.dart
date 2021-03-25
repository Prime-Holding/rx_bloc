import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/resources.dart';

import 'base/common_bindings/home_binding.dart';
import 'feature_home/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GetMaterialApp(
        initialRoute: '/',
        title: 'Puppies App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: ColorStyles.scaffoldBackgroundColor,
        ),
        getPages: [
          GetPage(name: '/', page: () => HomePage(), binding: HomeBinding()),
        ],
      );
}
