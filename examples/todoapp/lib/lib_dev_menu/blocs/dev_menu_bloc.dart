// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../service/dev_menu_service.dart';

part 'dev_menu_bloc.rxb.g.dart';

/// A contract class containing all events of the DevMenuBloC.
abstract class DevMenuBlocEvents {
  void tap();

  void saveProxy(String? proxy);
}

/// A contract class containing all states of the DevMenuBloC.
abstract class DevMenuBlocStates {
  Stream<void> get onDevMenuPresented;

  Stream<void> get proxySaved;

  Stream<String?> get getProxy;
}

@RxBloc()
class DevMenuBloc extends $DevMenuBloc {
  DevMenuBloc(DevMenuService devMenuService) : _service = devMenuService;

  int _tapCount = 0;
  static const thresholdTaps = 5;
  final DevMenuService _service;

  @override
  Stream<void> _mapToOnDevMenuPresentedState() => _$tapEvent
      .doOnData((_) => _tapCount += 1)
      .map((event) => _tapCount)
      .debounceTime(const Duration(milliseconds: 300))
      .where(_hasPassedThreshold);

  bool _hasPassedThreshold(int count) {
    _tapCount = 0;
    return count >= thresholdTaps;
  }

  @override
  Stream<void> _mapToProxySavedState() => _$saveProxyEvent
      .switchMap((proxy) => _service.saveProxy(proxy: proxy ?? '').asStream());

  @override
  Stream<String?> _mapToGetProxyState() =>
      _service.getProxy().asStream().shareReplay(maxSize: 1);
}
