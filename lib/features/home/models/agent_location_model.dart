class AgentLocation {
  final String orderId;
  final double latitude;
  final double longitude;
  final DateTime receivedAt;

  AgentLocation({
    required this.orderId,
    required this.latitude,
    required this.longitude,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();

  factory AgentLocation.fromMap(Map<String, dynamic> map) {
    return AgentLocation(
      orderId: map['orderId']?.toString() ?? '',
      latitude: (map['latitude'] is num)
          ? (map['latitude'] as num).toDouble()
          : double.tryParse(map['latitude'].toString()) ?? 0.0,
      longitude: (map['longitude'] is num)
          ? (map['longitude'] as num).toDouble()
          : double.tryParse(map['longitude'].toString()) ?? 0.0,
      // Optionally if backend starts sending timestamp, you can parse it here.
    );
  }

  Map<String, dynamic> toMap() => {
    'orderId': orderId,
    'latitude': latitude,
    'longitude': longitude,
    'receivedAt': receivedAt.toIso8601String(),
  };
}
