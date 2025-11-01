/// Base exception for crop history operations
class CropHistoryException implements Exception {
  final String message;
  
  const CropHistoryException(this.message);

  @override
  String toString() => 'CropHistoryException: $message';
}

/// Exception thrown when fetching the history list fails
class HistoryFetchException extends CropHistoryException {
  const HistoryFetchException(String message) : super(message);

  @override
  String toString() => 'HistoryFetchException: $message';
}

/// Exception thrown when fetching submission detail fails
class DetailFetchException extends CropHistoryException {
  const DetailFetchException(String message) : super(message);

  @override
  String toString() => 'DetailFetchException: $message';
}
