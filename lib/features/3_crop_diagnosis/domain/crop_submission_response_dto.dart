class CropSubmissionResponseDTO {
  final String submissionId;
  final String diseaseName;
  final String remedy;
  final String status;
  final double confidenceScore;
  final String imageUrl;

  CropSubmissionResponseDTO({
    required this.submissionId,
    required this.diseaseName,
    required this.remedy,
    required this.status,
    required this.confidenceScore,
    required this.imageUrl,
  });

  factory CropSubmissionResponseDTO.fromJson(Map<String, dynamic> json) {
    return CropSubmissionResponseDTO(
      submissionId: json['submissionId'] as String,
      diseaseName: json['diseaseName'] as String,
      remedy: json['remedy'] as String,
      status: json['status'] as String,
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
    );
  }
}
