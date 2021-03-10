import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'SEARCH PAGE',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: Get.find<FavoritePuppiesController>().incrementCount,
              child: Text('Increment Favorites'),
            ),
            ElevatedButton(
              onPressed: Get.find<FavoritePuppiesController>().decrementCount,
              child: Text('Decrement Favorites'),
            )
          ],
        ),
    );
  }
}
