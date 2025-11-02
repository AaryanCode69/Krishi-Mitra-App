import 'package:dio/dio.dart';
import 'package:krishi_mitra/core/constant/api_constants.dart';
import 'package:krishi_mitra/core/services/connectivity_service.dart';
import 'package:krishi_mitra/features/5_mandi_prices/domain/exceptions/mandi_price_exception.dart';
import 'package:krishi_mitra/features/5_mandi_prices/domain/mandi_price.dart';

/// Repository for fetching mandi (market) price data
class MandiRepository {
  final Dio _dio;
  final ConnectivityService _connectivityService;

  MandiRepository({
    required Dio dio,
    required ConnectivityService connectivityService,
  })  : _dio = dio,
        _connectivityService = connectivityService;

  /// Fetches market prices for a given state
  ///
  /// [state] - The state name (e.g., "Tamil Nadu")
  /// Returns [List<MandiPrice>] containing market price data
  /// Throws [MandiPriceException] if the request fails
  Future<List<MandiPrice>> fetchMandiPrices(String state) async {
    // Check network connectivity before making request
    final hasConnection = await _connectivityService.hasConnection();
    if (!hasConnection) {
      throw const MandiPriceException(
          'No internet connection. Please check your network and try again.');
    }

    try {
      // Make GET request to mandi prices endpoint with state as path parameter
      print('🌾 [Mandi Repository] Fetching prices for state: $state');
      print('🌾 [Mandi Repository] Full URL: ${ApiConstants.baseUrl}${ApiConstants.mandiPricesEndpoint}/$state');
      
      final response = await _dio.get(
        '${ApiConstants.mandiPricesEndpoint}/$state',
      );

      print('✅ [Mandi Repository] Response received: ${response.statusCode}');

      // Check if response is successful (200 OK)
      if (response.statusCode == 200) {
        // Parse response data as JSON array
        final List<dynamic> responseData = response.data as List<dynamic>;
        
        // Convert each JSON object to MandiPrice model
        return responseData
            .map((json) => MandiPrice.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      // If status code is not 200, throw exception
      throw const MandiPriceException('Unable to load data. Please try again.');
    } on DioException catch (e) {
      // Handle Dio-specific errors
      print('❌ [Mandi Repository] DioException occurred');
      print('❌ [Mandi Repository] Error type: ${e.type}');
      print('❌ [Mandi Repository] Status code: ${e.response?.statusCode}');
      print('❌ [Mandi Repository] Response data: ${e.response?.data}');
      
      if (e.response != null) {
        // Server returned an error response
        final statusCode = e.response!.statusCode;

        if (statusCode == 400) {
          throw const MandiPriceException(
              'Invalid state selected. Please try again.');
        } else if (statusCode == 401) {
          throw const MandiPriceException(
              'Session expired. Please login again.');
        } else if (statusCode == 403) {
          throw const MandiPriceException(
              'Access denied. Please login again.');
        } else if (statusCode == 404) {
          throw const MandiPriceException(
              'Service not available. Please try again later.');
        } else if (statusCode! >= 500) {
          throw const MandiPriceException(
              'Server error. Please try again later.');
        }

        throw const MandiPriceException('Unable to load data. Please try again.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const MandiPriceException(
            'Connection timeout. Please check your internet.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const MandiPriceException(
            'No internet connection. Please check your network and try again.');
      }

      throw const MandiPriceException('Unable to load data. Please try again.');
    } catch (e) {
      // Handle any other errors including parsing errors
      if (e is FormatException) {
        throw const MandiPriceException('Unable to load data. Please try again.');
      }
      throw MandiPriceException('Unexpected error: ${e.toString()}');
    }
  }
}
