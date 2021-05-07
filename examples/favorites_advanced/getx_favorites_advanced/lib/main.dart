import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/resources.dart';

import 'base/routes/app_pages.dart';

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
        getPages: AppPages.routes,
    debugShowCheckedModeBanner: false,
      );
}
