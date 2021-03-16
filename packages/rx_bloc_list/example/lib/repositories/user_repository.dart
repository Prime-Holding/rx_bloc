import 'package:example/models/user_model.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

class UserRepository {
  Future<PaginatedList<User>> fetchPage(int page, int pageSize) async {
    await Future.delayed(Duration(seconds: 2));

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
          return User(
            id: realIndex,
            name: 'User #$realIndex',
          );
        },
      ),
      pageSize: pageSize,
    );
  }
}
