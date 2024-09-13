import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityDataSource {
  Stream<bool> connected() => Connectivity()
      .onConnectivityChanged
      .where((event) =>
          event.contains(ConnectivityResult.mobile) ||
          event.contains(ConnectivityResult.wifi) ||
          event.contains(ConnectivityResult.none))
      .map((event) => !event.contains(ConnectivityResult.none))
      .distinct();
}
