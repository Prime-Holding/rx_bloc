{{> licence.dart }}

import 'package:widget_toolkit/item_picker.dart';

import '../models/data_model.dart';

class DataService extends ItemPickerService<DataModel> {
  DataService();

  @override
  Future<List<DataModel>> getItems() => Future.delayed(
        const Duration(seconds: 3),
        () => List.generate(
          20,
          (index) => DataModel(
            name: 'Person $index',
            description:
                'This may be very long description for user named Person $index',
          ),
        ),
      );
}
