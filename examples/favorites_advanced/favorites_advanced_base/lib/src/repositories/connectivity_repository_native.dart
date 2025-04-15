import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityRepository {
  Future<bool> isConnected() async {
    return (await Connectivity().checkConnectivity()) !=
        ConnectivityResult.none;
  }
}
