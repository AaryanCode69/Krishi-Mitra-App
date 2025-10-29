class CropAnalysisException implements Exception {
  final String message;

  CropAnalysisException(this.message);

  @override
  String toString() => 'CropAnalysisException: $message';
}

class PresignedUrlException extends CropAnalysisException {
  PresignedUrlException(super.message);

  @override
  String toString() => 'PresignedUrlException: $message';
}

class UploadFailedException extends CropAnalysisException {
  UploadFailedException(super.message);

  @override
  String toString() => 'UploadFailedException: $message';
}

class ConfirmUploadException extends CropAnalysisException {
  ConfirmUploadException(super.message);

  @override
  String toString() => 'ConfirmUploadException: $message';
}

class ResultFetchException extends CropAnalysisException {
  ResultFetchException(super.message);

  @override
  String toString() => 'ResultFetchException: $message';
}
