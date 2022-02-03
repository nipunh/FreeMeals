import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:freemeals/enums/connectivity_status.dart';


class ConnectivityService {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      var connectionStatus = await _getStatusFromResult(result);
      connectionStatusController.sink.add(connectionStatus);
    });
  }

  Future<ConnectivityStatus> _getStatusFromResult(
      ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      final connectionStatus = await DataConnectionChecker().connectionStatus;
      if (connectionStatus == DataConnectionStatus.connected) {
        return ConnectivityStatus.Connected;
      } else {
        return ConnectivityStatus.None;
      }
    } else {
      return ConnectivityStatus.None;
    }
  }

  void connectionNone() {
    connectionStatusController.sink.add(ConnectivityStatus.None);
  }

  void connectionConnected() {
    connectionStatusController.sink.add(ConnectivityStatus.Connected);
  }

  Future<DataConnectionStatus> checkStatus() async {
    try {
      return await DataConnectionChecker().connectionStatus;
    } catch (err) {
      print('error Connectivity service - check status = ' + err.toString());
      throw Exception(err);
    }
  }
}
