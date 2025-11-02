/// Exception for mandi price operations
class MandiPriceException implements Exception {
  final String message;

  const MandiPriceException(this.message);

  @override
  String toString() => 'MandiPriceException: $message';
}
