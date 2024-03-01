import 'package:connectivity_plus/connectivity_plus.dart';

import 'cubit/network_helper_bloc.dart';

class NetworkHelper {
  static void observeNetwork() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        NetworkBloc().add(NetworkNotify());
      } else {
        NetworkBloc().add(NetworkNotify(isConnected: true));
      }
    });
  }

  static Future<bool> isConnected() async {
    var conn = await Connectivity().checkConnectivity();
    return conn == ConnectivityResult.mobile || conn == ConnectivityResult.wifi;
  }
}
