class PresignedUrlDTO {
  final String url;
  final String objectKey;

  PresignedUrlDTO({
    required this.url,
    required this.objectKey,
  });

  factory PresignedUrlDTO.fromJson(Map<String, dynamic> json) {
    return PresignedUrlDTO(
      url: json['url'] as String,
      objectKey: json['objectKey'] as String,
    );
  }
}
