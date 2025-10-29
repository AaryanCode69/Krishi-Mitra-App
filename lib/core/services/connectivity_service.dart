import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for checking network connectivity
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connectivity
  /// Returns true if connected to mobile or wifi, false otherwise
  Future<bool> hasConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      
      // Check if connected to mobile data or wifi
      return connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi);
    } catch (e) {
      // If connectivity check fails, assume no connection
      return false;
    }
  }

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
