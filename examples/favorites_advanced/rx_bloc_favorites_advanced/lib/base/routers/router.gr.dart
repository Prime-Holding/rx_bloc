// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';

import '../../feature_home/views/home_page.dart';
import '../../feature_puppy_details/views/puppy_details_page.dart';
import '../../feature_puppy_edit/views/puppy_edit_page.dart';

class Routes {
  static const String homePage = '/';
  static const String puppyDetailsPage = '/puppy-details-page';
  static const String puppyEditPage = '/puppy-edit-page';
  static const all = <String>{
    homePage,
    puppyDetailsPage,
    puppyEditPage,
  };
}

class MyRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homePage, page: HomePage),
    RouteDef(Routes.puppyDetailsPage, page: PuppyDetailsPage),
    RouteDef(Routes.puppyEditPage, page: PuppyEditPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    HomePage: (data) {
      final args = data.getArgs<HomePageArguments>(
        orElse: () => HomePageArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomePage(key: args.key).wrappedRoute(context),
        settings: data,
      );
    },
    PuppyDetailsPage: (data) {
      final args = data.getArgs<PuppyDetailsPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => PuppyDetailsPage(
          puppy: args.puppy,
          key: args.key,
        ).wrappedRoute(context),
        settings: data,
      );
    },
    PuppyEditPage: (data) {
      final args = data.getArgs<PuppyEditPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => PuppyEditPage(
          puppy: args.puppy,
          key: args.key,
        ).wrappedRoute(context),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// HomePage arguments holder class
class HomePageArguments {
  final Key key;
  HomePageArguments({this.key});
}

/// PuppyDetailsPage arguments holder class
class PuppyDetailsPageArguments {
  final Puppy puppy;
  final Key key;
  PuppyDetailsPageArguments({@required this.puppy, this.key});
}

/// PuppyEditPage arguments holder class
class PuppyEditPageArguments {
  final Puppy puppy;
  final Key key;
  PuppyEditPageArguments({@required this.puppy, this.key});
}
