import 'package:dio/dio.dart';
import 'package:krishi_mitra/core/services/connectivity_service.dart';
import 'package:krishi_mitra/features/4_crop_history/domain/crop_submission_summary.dart';
import 'package:krishi_mitra/features/4_crop_history/domain/crop_submission_detail.dart';
import 'package:krishi_mitra/features/4_crop_history/domain/exceptions/crop_history_exceptions.dart';

/// Repository for crop history operations
class CropHistoryRepository {
  final Dio _dio; // Dio instance with JWT interceptor for authenticated requests
  final ConnectivityService _connectivityService;

  CropHistoryRepository({
    required Dio dio,
    required ConnectivityService connectivityService,
  })  : _dio = dio,
        _connectivityService = connectivityService;

  /// Fetches the list of all crop submissions for the authenticated user
  ///
  /// Makes GET request to /api/submissions/history endpoint
  /// Returns [List<CropSubmissionSummary>] containing submission summaries
  /// Throws [HistoryFetchException] if the request fails
  Future<List<CropSubmissionSummary>> fetchHistoryList() async {
    // Check network connectivity before making request
    final hasConnection = await _connectivityService.hasConnection();
    if (!hasConnection) {
      throw const HistoryFetchException(
          'No internet connection. Please check your network and try again.');
    }

    try {
      // Make GET request to history endpoint
      final response = await _dio.get('/api/submissions/history');

      // Check if response is successful (200 OK)
      if (response.statusCode == 200) {
        // Parse response data - expecting a list
        if (response.data is List) {
          final List<dynamic> dataList = response.data as List;
          
          // Convert each item to CropSubmissionSummary
          return dataList.map((item) {
            try {
              if (item is Map<String, dynamic>) {
                return CropSubmissionSummary.fromJson(item);
              } else if (item is Map) {
                // Convert Map to Map<String, dynamic>
                final Map<String, dynamic> itemData =
                    Map<String, dynamic>.from(item);
                return CropSubmissionSummary.fromJson(itemData);
              } else {
                throw const HistoryFetchException('Invalid item format in response');
              }
            } catch (e) {
              throw HistoryFetchException('Failed to parse submission: ${e.toString()}');
            }
          }).toList();
        } else {
          throw const HistoryFetchException('Invalid response format from server');
        }
      }

      // If status code is not 200, throw exception
      throw const HistoryFetchException('Failed to fetch history list');
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server returned an error response
        final statusCode = e.response!.statusCode;

        // Safely extract error message
        String errorMessage = 'Failed to fetch history list';
        try {
          if (e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            errorMessage = errorData['message']?.toString() ??
                errorData['error']?.toString() ??
                errorMessage;
          } else if (e.response!.data is String) {
            errorMessage = e.response!.data as String;
          }
        } catch (_) {
          // Keep default error message if parsing fails
        }

        if (statusCode == 400) {
          throw HistoryFetchException('Invalid request: $errorMessage');
        } else if (statusCode == 401 || statusCode == 403) {
          throw const HistoryFetchException('Unauthorized. Please login again');
        } else if (statusCode == 404) {
          throw const HistoryFetchException('History service not found');
        } else if (statusCode! >= 500) {
          throw const HistoryFetchException('Server error. Please try again later');
        }

        throw HistoryFetchException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const HistoryFetchException(
            'Connection timeout. Please check your internet');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const HistoryFetchException('No internet connection');
      }

      throw const HistoryFetchException('An error occurred. Please try again');
    } catch (e) {
      // Handle any other errors including type casting errors
      if (e is HistoryFetchException) {
        rethrow;
      }
      throw HistoryFetchException('Unexpected error: ${e.toString()}');
    }
  }

  /// Fetches detailed information for a specific submission
  ///
  /// [submissionId] - The UUID of the submission to fetch
  /// Makes GET request to /api/crops/processed/{submissionId} endpoint
  /// Returns [CropSubmissionDetail] containing complete analysis information
  /// Throws [DetailFetchException] if the request fails
  Future<CropSubmissionDetail> fetchHistoryDetail(String submissionId) async {
    // Check network connectivity before making request
    final hasConnection = await _connectivityService.hasConnection();
    if (!hasConnection) {
      throw const DetailFetchException(
          'No internet connection. Please check your network and try again.');
    }

    try {
      // Make GET request to detail endpoint
      final response = await _dio.get('/api/crops/processed/$submissionId');

      // Check if response is successful (200 OK)
      if (response.statusCode == 200) {
        // Parse response data - handle both Map and other types safely
        if (response.data is Map<String, dynamic>) {
          return CropSubmissionDetail.fromJson(
              response.data as Map<String, dynamic>);
        } else if (response.data is Map) {
          // Convert Map to Map<String, dynamic>
          final Map<String, dynamic> responseData =
              Map<String, dynamic>.from(response.data as Map);
          return CropSubmissionDetail.fromJson(responseData);
        } else {
          throw const DetailFetchException('Invalid response format from server');
        }
      }

      // If status code is not 200, throw exception
      throw const DetailFetchException('Failed to fetch submission detail');
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server returned an error response
        final statusCode = e.response!.statusCode;

        // Safely extract error message
        String errorMessage = 'Failed to fetch submission detail';
        try {
          if (e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            errorMessage = errorData['message']?.toString() ??
                errorData['error']?.toString() ??
                errorMessage;
          } else if (e.response!.data is String) {
            errorMessage = e.response!.data as String;
          }
        } catch (_) {
          // Keep default error message if parsing fails
        }

        if (statusCode == 400) {
          throw DetailFetchException('Invalid submission ID: $errorMessage');
        } else if (statusCode == 401 || statusCode == 403) {
          throw const DetailFetchException('Unauthorized. Please login again');
        } else if (statusCode == 404) {
          throw const DetailFetchException(
              'Submission not found. It may still be processing');
        } else if (statusCode! >= 500) {
          throw const DetailFetchException('Server error. Please try again later');
        }

        throw DetailFetchException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const DetailFetchException(
            'Connection timeout. Please check your internet');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const DetailFetchException('No internet connection');
      }

      throw const DetailFetchException('An error occurred. Please try again');
    } catch (e) {
      // Handle any other errors including type casting errors
      if (e is DetailFetchException) {
        rethrow;
      }
      throw DetailFetchException('Unexpected error: ${e.toString()}');
    }
  }
}
