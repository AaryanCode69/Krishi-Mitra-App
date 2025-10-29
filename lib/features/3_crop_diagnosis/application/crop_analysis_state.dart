import 'package:image_picker/image_picker.dart';
import '../domain/crop_submission_response_dto.dart';

enum CropAnalysisStatus {
  initial,
  selectingImage,
  imageSelected,
  gettingUrl,
  uploadingToS3,
  confirmingUpload,
  pollingResult,
  completed,
  error,
}

class CropAnalysisState {
  final CropAnalysisStatus status;
  final XFile? selectedImage;
  final String? errorMessage;
  final String? submissionId;
  final CropSubmissionResponseDTO? result;
  final int pollingAttempts;

  const CropAnalysisState({
    required this.status,
    this.selectedImage,
    this.errorMessage,
    this.submissionId,
    this.result,
    this.pollingAttempts = 0,
  });

  CropAnalysisState copyWith({
    CropAnalysisStatus? status,
    XFile? selectedImage,
    String? errorMessage,
    String? submissionId,
    CropSubmissionResponseDTO? result,
    int? pollingAttempts,
  }) {
    return CropAnalysisState(
      status: status ?? this.status,
      selectedImage: selectedImage ?? this.selectedImage,
      errorMessage: errorMessage ?? this.errorMessage,
      submissionId: submissionId ?? this.submissionId,
      result: result ?? this.result,
      pollingAttempts: pollingAttempts ?? this.pollingAttempts,
    );
  }

  factory CropAnalysisState.initial() {
    return const CropAnalysisState(
      status: CropAnalysisStatus.initial,
    );
  }
}
