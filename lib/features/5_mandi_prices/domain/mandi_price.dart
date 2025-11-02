class MandiPrice {
  final String state;
  final String district;
  final String market;
  final String commodity;
  final String arrivalDate;
  final int minPrice;
  final int maxPrice;
  final int modalPrice;

  const MandiPrice({
    required this.state,
    required this.district,
    required this.market,
    required this.commodity,
    required this.arrivalDate,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
  });

  factory MandiPrice.fromJson(Map<String, dynamic> json) {
    try {
      return MandiPrice(
        state: json['state']?.toString() ?? '',
        district: json['district']?.toString() ?? '',
        market: json['market']?.toString() ?? '',
        commodity: json['commodity']?.toString() ?? '',
        arrivalDate: json['arrivalDate']?.toString() ?? '',
        minPrice: _parsePrice(json['minPrice']),
        maxPrice: _parsePrice(json['maxPrice']),
        modalPrice: _parsePrice(json['modalPrice']),
      );
    } catch (e) {
      throw FormatException('Failed to parse MandiPrice: $e');
    }
  }

  /// Helper method to handle potential string-to-int conversions for price fields
  static int _parsePrice(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) return value.toInt();
    return 0;
  }
}
