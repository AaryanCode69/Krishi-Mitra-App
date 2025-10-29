import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../data/crop_repository.dart';
import '../domain/exceptions/crop_analysis_exceptions.dart';
import 'crop_analysis_state.dart';

/// Notifier for managing crop analysis state and orchestrating the analysis workflow
///
/// Handles app lifecycle changes to maintain state during backgrounding
class CropAnalysisNotifier extends StateNotifier<CropAnalysisState> {
  final CropRepository _repository;
  Timer? _pollingTimer;
  bool _isDisposed = false;
  bool _isPaused = false;

  CropAnalysisNotifier({required CropRepository repository})
    : _repository = repository,
      super(CropAnalysisState.initial());

  /// Orchestrates the complete crop analysis workflow
  ///
  /// Accepts an [imageFile] and performs the following steps:
  /// 1. Store selected image in state
  /// 2. Request presigned URL from backend
  /// 3. Upload image to S3
  /// 4. Confirm upload with backend
  /// 5. Start polling for results
  Future<void> startAnalysis(XFile imageFile) async {
    try {
      // Store selected image and update status
      state = state.copyWith(
        status: CropAnalysisStatus.imageSelected,
        selectedImage: imageFile,
        errorMessage: null,
      );

      // Step 1: Get presigned URL
      state = state.copyWith(status: CropAnalysisStatus.gettingUrl);
      final presignedUrlDto = await _repository.getPresignedUrl(imageFile.name);

      // Step 2: Upload to S3
      state = state.copyWith(status: CropAnalysisStatus.uploadingToS3);
      final file = File(imageFile.path);
      final uploadSuccess = await _repository.uploadImageToS3(
        presignedUrlDto.url,
        file,
      );

      if (!uploadSuccess) {
        throw UploadFailedException('Upload to S3 failed');
      }

      // Step 3: Confirm upload
      state = state.copyWith(status: CropAnalysisStatus.confirmingUpload);
      final confirmResponse = await _repository.confirmUpload(
        presignedUrlDto.objectKey,
      );

      // Step 4: Start polling for results
      state = state.copyWith(
        status: CropAnalysisStatus.pollingResult,
        submissionId: confirmResponse.submissionId,
      );
      await _pollForResult(confirmResponse.submissionId);
    } on PresignedUrlException catch (e) {
      state = state.copyWith(
        status: CropAnalysisStatus.error,
        errorMessage: e.message,
      );
    } on UploadFailedException catch (e) {
      state = state.copyWith(
        status: CropAnalysisStatus.error,
        errorMessage: e.message,
      );
    } on ConfirmUploadException catch (e) {
      state = state.copyWith(
        status: CropAnalysisStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: CropAnalysisStatus.error,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Polls the backend for processing results with timeout logic
  ///
  /// Polls every 5 seconds for a maximum of 12 attempts (60 seconds)
  /// Breaks on: Completed, Failed, or timeout
  /// Handles app backgrounding by maintaining state
  Future<void> _pollForResult(String submissionId) async {
    const maxAttempts = 12;
    const pollInterval = Duration(seconds: 5);

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      // Check if notifier has been disposed
      if (_isDisposed || !mounted) {
        return;
      }

      // Skip polling if paused (app in background)
      if (_isPaused) {
        // Wait a bit and check again
        await Future.delayed(const Duration(seconds: 1));
        attempt--; // Don't count this as an attempt
        continue;
      }

      try {
        // Wait before polling (except for first attempt)
        if (attempt > 1) {
          await Future.delayed(pollInterval);
        }

        // Check again after delay if notifier is still mounted and not paused
        if (_isDisposed || !mounted || _isPaused) {
          if (_isPaused) {
            attempt--; // Don't count this as an attempt
            continue;
          }
          return;
        }

        // Update polling attempts
        state = state.copyWith(pollingAttempts: attempt);

        // Fetch processing result
        final result = await _repository.getProcessingResult(submissionId);

        // Check if still mounted before updating state
        if (_isDisposed || !mounted) {
          return;
        }

        // Check status
        if (result.status.toLowerCase() == 'completed') {
          // Processing completed successfully
          state = state.copyWith(
            status: CropAnalysisStatus.completed,
            result: result,
          );
          return;
        } else if (result.status.toLowerCase() == 'failed') {
          // Processing failed
          state = state.copyWith(
            status: CropAnalysisStatus.error,
            errorMessage:
                'Analysis failed. Please try again with a different image.',
          );
          return;
        }
        // If status is "Processing", continue to next iteration
      } on ResultFetchException catch (e) {
        // Check if still mounted before updating state
        if (_isDisposed || !mounted) {
          return;
        }
        // Handle fetch errors
        state = state.copyWith(
          status: CropAnalysisStatus.error,
          errorMessage: e.message,
        );
        return;
      } catch (e) {
        // Check if still mounted before updating state
        if (_isDisposed || !mounted) {
          return;
        }
        // Handle unexpected errors
        state = state.copyWith(
          status: CropAnalysisStatus.error,
          errorMessage: 'Error fetching results: ${e.toString()}',
        );
        return;
      }
    }

    // Check if still mounted before updating state
    if (_isDisposed || !mounted) {
      return;
    }

    // Timeout reached
    state = state.copyWith(
      status: CropAnalysisStatus.error,
      errorMessage: 'Analysis timeout. Please try again.',
    );
  }

  /// Resets the state to initial
  void reset() {
    state = CropAnalysisState.initial();
  }

  /// Retries analysis from error state
  Future<void> retry() async {
    if (state.selectedImage != null) {
      await startAnalysis(state.selectedImage!);
    } else {
      // If no image is stored, just reset to initial
      reset();
    }
  }

  /// Pause polling when app goes to background
  /// State is maintained so polling can resume when app returns to foreground
  void pause() {
    _isPaused = true;
  }

  /// Resume polling when app returns to foreground
  void resume() {
    _isPaused = false;
    // If we were polling when paused, continue polling
    if (state.status == CropAnalysisStatus.pollingResult &&
        state.submissionId != null) {
      // Continue polling from where we left off
      _pollForResult(state.submissionId!);
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing polling timer
    _pollingTimer?.cancel();
    _isDisposed = true;
    super.dispose();
  }
}
