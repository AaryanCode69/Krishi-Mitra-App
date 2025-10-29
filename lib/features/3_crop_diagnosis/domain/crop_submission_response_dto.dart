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
    try {
      return CropSubmissionResponseDTO(
        submissionId: json['submissionId']?.toString() ?? '',
        diseaseName: json['diseaseName']?.toString() ?? 'Unknown',
        remedy: json['remedy']?.toString() ?? 'No remedy available',
        status: json['status']?.toString() ?? 'unknown',
        confidenceScore: (json['confidenceScore'] is num) 
            ? (json['confidenceScore'] as num).toDouble() 
            : 0.0,
        imageUrl: json['imageUrl']?.toString() ?? '',
      );
    } catch (e) {
      throw FormatException('Failed to parse CropSubmissionResponseDTO: $e. JSON: $json');
    }
  }
}
