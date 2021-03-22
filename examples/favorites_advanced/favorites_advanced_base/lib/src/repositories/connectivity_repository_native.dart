import 'package:connectivity/connectivity.dart';

class ConnectivityRepository {
  Future<bool> isConnected() async {
    return (await Connectivity().checkConnectivity()) !=
        ConnectivityResult.none;
  }
}
