import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/resources.dart';
import 'package:getx_favorites_advanced/base/network/network_binding.dart';

import 'base/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GetMaterialApp(
        initialRoute: '/',
        initialBinding: NetworkBinding(),
        title: 'Puppies App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: ColorStyles.scaffoldBackgroundColor,
        ),
        getPages: AppPages.routes,
      );
}
