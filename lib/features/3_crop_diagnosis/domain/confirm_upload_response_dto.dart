class ConfirmUploadResponseDTO {
  final String submissionId;
  final String bucketName;
  final String objectKey;

  ConfirmUploadResponseDTO({
    required this.submissionId,
    required this.bucketName,
    required this.objectKey,
  });

  factory ConfirmUploadResponseDTO.fromJson(Map<String, dynamic> json) {
    return ConfirmUploadResponseDTO(
      submissionId: json['submissionId'] as String,
      bucketName: json['bucketName'] as String,
      objectKey: json['objectKey'] as String,
    );
  }
}
