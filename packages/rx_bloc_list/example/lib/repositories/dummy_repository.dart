import 'package:example/models/dummy.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

class DummyRepository implements DataRepositoryInterface<Dummy> {
  @override
  Future<List<Dummy>> fetchPage(int page) async {
    await Future.delayed(Duration(seconds: 2));

    if (page > 3) return [];

    final itemsPerPage = 10;
    return List.generate(
      itemsPerPage,
      (index) {
        final realIndex = itemsPerPage * page + index;
        return Dummy(
          id: realIndex,
          name: 'Dummy_$realIndex',
          lastLogin: DateTime.now().toString(),
        );
      },
    );
  }
}
