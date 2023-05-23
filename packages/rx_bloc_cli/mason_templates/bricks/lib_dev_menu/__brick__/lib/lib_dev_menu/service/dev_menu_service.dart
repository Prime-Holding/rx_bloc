import '../repository/dev_menu_repository.dart';

class DevMenuService {
  DevMenuService(this._repository);

  final DevMenuRepository _repository;

  Future<void> saveProxy({required String proxy}) async =>
      _repository.saveProxy(proxy);

  Future<String?> getProxy() async => await _repository.getProxy();
}
