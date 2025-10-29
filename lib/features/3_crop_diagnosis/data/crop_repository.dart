import 'dart:io';
import 'package:dio/dio.dart';
import 'package:krishi_mitra/core/services/connectivity_service.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/domain/confirm_upload_response_dto.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/domain/crop_submission_response_dto.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/domain/exceptions/crop_analysis_exceptions.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/domain/presigned_url_dto.dart';

/// Repository for crop diagnosis and image analysis operations
class CropRepository {
  final Dio _dio; // Dio instance with JWT interceptor for authenticated requests
  final Dio _s3Dio; // Separate Dio instance for S3 uploads (no auth headers)
  final ConnectivityService _connectivityService;

  CropRepository({
    required Dio dio,
    required Dio s3Dio,
    required ConnectivityService connectivityService,
  })  : _dio = dio,
        _s3Dio = s3Dio,
        _connectivityService = connectivityService;

  /// Requests a presigned URL from the backend for uploading an image to S3
  ///
  /// [fileName] - The name of the file to upload
  /// Returns [PresignedUrlDTO] containing the presigned URL and object key
  /// Throws [PresignedUrlException] if the request fails
  Future<PresignedUrlDTO> getPresignedUrl(String fileName) async {
    // Check network connectivity before making request
    final hasConnection = await _connectivityService.hasConnection();
    if (!hasConnection) {
      throw PresignedUrlException('No internet connection. Please check your network and try again.');
    }

    try {
      // Make GET request to presigned URL endpoint
      final response = await _dio.get(
        '/upload/presignedurl',
        queryParameters: {'fileName': fileName},
      );

      // Check if response is successful (200 OK)
      if (response.statusCode == 200) {
        // Parse response data
        final responseData = response.data as Map<String, dynamic>;
        return PresignedUrlDTO.fromJson(responseData);
      }

      // If status code is not 200, throw exception
      throw PresignedUrlException('Failed to get presigned URL');
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server returned an error response
        final statusCode = e.response!.statusCode;
        final errorMessage = e.response!.data?['message'] ??
            e.response!.data?['error'] ??
            'Failed to get presigned URL';

        if (statusCode == 400) {
          throw PresignedUrlException('Invalid file name: $errorMessage');
        } else if (statusCode == 401) {
          throw PresignedUrlException('Unauthorized. Please login again');
        } else if (statusCode == 404) {
          throw PresignedUrlException('Service not found');
        } else if (statusCode! >= 500) {
          throw PresignedUrlException('Server error. Please try again later');
        }

        throw PresignedUrlException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw PresignedUrlException(
            'Connection timeout. Please check your internet');
      } else if (e.type == DioExceptionType.connectionError) {
        throw PresignedUrlException('No internet connection');
      }

      throw PresignedUrlException('An error occurred. Please try again');
    } catch (e) {
      // Handle any other errors
      throw PresignedUrlException('Unexpected error: ${e.toString()}');
    }
  }

  /// Uploads an image file directly to S3 using a presigned URL
  ///
  /// [presignedUrl] - The presigned URL obtained from getPresignedUrl
  /// [imageFile] - The image file to upload
  /// Returns true if upload is successful (200 OK), false otherwise
  /// Throws [UploadFailedException] if the upload fails
  Future<bool> uploadImageToS3(String presignedUrl, File imageFile) async {
    // Check network connectivity before making request
    final hasConnection = await _connectivityService.hasConnection();
    if (!hasConnection) {
      throw UploadFailedException('No internet connection. Please check your network and try again.');
    }

    try {
      // Read file as bytes
      final fileBytes = await imageFile.readAsBytes();
      final fileSize = fileBytes.length;

      // Make PUT request to presigned URL with binary data
      final response = await _s3Dio.put(
        presignedUrl,
        data: fileBytes,
        options: Options(
          headers: {
            'Content-Type': 'image/jpeg',
            'Content-Length': fileSize.toString(),
          },
          // Don't follow redirects for S3
          followRedirects: false,
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      // Return true on 200 OK
      return response.statusCode == 200;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final errorMessage = e.response!.data?.toString() ??
            'Failed to upload image to S3';

        if (statusCode == 403) {
          throw UploadFailedException(
              'Access denied. Presigned URL may have expired');
        } else if (statusCode == 404) {
          throw UploadFailedException('Upload destination not found');
        } else if (statusCode! >= 400) {
          throw UploadFailedException('Upload failed: $errorMessage');
        }

        throw UploadFailedException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw UploadFailedException(
            'Upload timeout. Please check your internet connection');
      } else if (e.type == DioExceptionType.connectionError) {
        throw UploadFailedException('No internet connection');
      }

      throw UploadFailedException('Upload failed. Please try again');
    } catch (e) {
      // Handle any other errors (e.g., file read errors)
      throw UploadFailedException('Unexpected error: ${e.toString()}');
    }
  }

  /// Confirms the upload with the backend after successful S3 upload
  ///
  /// [objectKey] - The S3 object key from the presigned URL response
  /// Returns [ConfirmUploadResponseDTO] containing submission details
  /// Throws [ConfirmUploadException] if confirmation fails
  Future<ConfirmUploadResponseDTO> confirmUpload(String objectKey) async {
    // Check network connectivity before making request
    final hasConnection = await _connectivityService.hasConnection();
    if (!hasConnection) {
      throw ConfirmUploadException('No internet connection. Please check your network and try again.');
    }

    try {
      // Make POST request to confirm upload endpoint
      final response = await _dio.post(
        '/upload/confirmUpload',
        queryParameters: {'objectKey': objectKey},
      );

      // Check if response is successful (200 OK or 201 Created)
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Parse response data
        final responseData = response.data as Map<String, dynamic>;
        return ConfirmUploadResponseDTO.fromJson(responseData);
      }

      // If status code is not in 2xx range, throw exception
      throw ConfirmUploadException('Failed to confirm upload');
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server returned an error response
        final statusCode = e.response!.statusCode;
        final errorMessage = e.response!.data?['message'] ??
            e.response!.data?['error'] ??
            'Failed to confirm upload';

        if (statusCode == 400) {
          throw ConfirmUploadException('Invalid object key: $errorMessage');
        } else if (statusCode == 401) {
          throw ConfirmUploadException('Unauthorized. Please login again');
        } else if (statusCode == 404) {
          throw ConfirmUploadException('Upload not found or service unavailable');
        } else if (statusCode! >= 500) {
          throw ConfirmUploadException('Server error. Please try again later');
        }

        throw ConfirmUploadException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ConfirmUploadException(
            'Connection timeout. Please check your internet');
      } else if (e.type == DioExceptionType.connectionError) {
        throw ConfirmUploadException('No internet connection');
      }

      throw ConfirmUploadException('An error occurred. Please try again');
    } catch (e) {
      // Handle any other errors
      throw ConfirmUploadException('Unexpected error: ${e.toString()}');
    }
  }

  /// Retrieves the processing result for a submitted crop image
  ///
  /// [submissionId] - The submission ID from the confirm upload response
  /// Returns [CropSubmissionResponseDTO] containing analysis results
  /// Throws [ResultFetchException] if fetching the result fails
  Future<CropSubmissionResponseDTO> getProcessingResult(
      String submissionId) async {
    // Check network connectivity before making request
    final hasConnection = await _connectivityService.hasConnection();
    if (!hasConnection) {
      throw ResultFetchException('No internet connection. Please check your network and try again.');
    }

    try {
      // Make GET request to processed result endpoint
      final response = await _dio.get('/upload/processed/$submissionId');

      // Check if response is successful (200 OK)
      if (response.statusCode == 200) {
        // Parse response data
        final responseData = response.data as Map<String, dynamic>;
        return CropSubmissionResponseDTO.fromJson(responseData);
      }

      // If status code is not 200, throw exception
      throw ResultFetchException('Failed to fetch processing result');
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server returned an error response
        final statusCode = e.response!.statusCode;
        final errorMessage = e.response!.data?['message'] ??
            e.response!.data?['error'] ??
            'Failed to fetch processing result';

        if (statusCode == 400) {
          throw ResultFetchException('Invalid submission ID: $errorMessage');
        } else if (statusCode == 401) {
          throw ResultFetchException('Unauthorized. Please login again');
        } else if (statusCode == 404) {
          throw ResultFetchException('Result not found. It may still be processing');
        } else if (statusCode! >= 500) {
          throw ResultFetchException('Server error. Please try again later');
        }

        throw ResultFetchException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResultFetchException(
            'Connection timeout. Please check your internet');
      } else if (e.type == DioExceptionType.connectionError) {
        throw ResultFetchException('No internet connection');
      }

      throw ResultFetchException('An error occurred. Please try again');
    } catch (e) {
      // Handle any other errors
      throw ResultFetchException('Unexpected error: ${e.toString()}');
    }
  }
}
