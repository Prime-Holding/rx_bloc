import 'package:example/models/dummy.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

class DummyRepository {
  Future<PaginatedList<Dummy>> fetchPage(int page, int pageSize) async {
    await Future.delayed(Duration(seconds: 1));

    if (page > 10)
      return PaginatedList(
        list: [],
        pageSize: pageSize,
      );

    return PaginatedList(
      list: List.generate(
        pageSize,
        (index) {
          final realIndex = ((page - 1) * pageSize) + index;
          return Dummy(
            id: realIndex,
            name: 'Dummy_$realIndex',
            lastLogin: DateTime.now().toString(),
          );
        },
      ),
      pageSize: pageSize,
    );
  }
}
