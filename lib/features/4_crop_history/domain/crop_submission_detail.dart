class CropSubmissionDetail {
  final String submissionId;
  final String diseaseName;
  final String remedy;
  final String status;
  final double confidenceScore;
  final String imageUrl;

  const CropSubmissionDetail({
    required this.submissionId,
    required this.diseaseName,
    required this.remedy,
    required this.status,
    required this.confidenceScore,
    required this.imageUrl,
  });

  factory CropSubmissionDetail.fromJson(Map<String, dynamic> json) {
    try {
      return CropSubmissionDetail(
        submissionId: json['submissionId']?.toString() ?? '',
        diseaseName: json['diseaseName']?.toString() ?? 'Unknown',
        remedy: json['remedy']?.toString() ?? '',
        status: json['status']?.toString() ?? 'PROCESSING',
        confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0.0,
        imageUrl: json['imageUrl']?.toString() ?? '',
      );
    } catch (e) {
      throw FormatException('Failed to parse CropSubmissionDetail: $e');
    }
  }
}
