enum CropHealthStatus { healthy, needsAttention }

class CropSubmission {
  const CropSubmission({
    required this.cropName,
    required this.status,
    required this.submittedAt,
    this.imageAsset,
  });

  final String cropName;
  final CropHealthStatus status;
  final DateTime submittedAt;
  final String? imageAsset;
}
