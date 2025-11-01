class CropSubmissionSummary {
  final String id;
  final String imageUrl;
  final String status;
  final String diseaseName;

  const CropSubmissionSummary({
    required this.id,
    required this.imageUrl,
    required this.status,
    required this.diseaseName,
  });

  factory CropSubmissionSummary.fromJson(Map<String, dynamic> json) {
    try {
      return CropSubmissionSummary(
        id: json['id']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString() ?? '',
        status: json['status']?.toString() ?? 'PROCESSING',
        diseaseName: json['diseaseName']?.toString() ?? 'Unknown',
      );
    } catch (e) {
      throw FormatException('Failed to parse CropSubmissionSummary: $e');
    }
  }
}
