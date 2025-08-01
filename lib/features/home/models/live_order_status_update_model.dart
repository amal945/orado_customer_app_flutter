class LiveOrderStatusUpdate {
  final String orderId;
  final String newStatus;
  final String previousStatus;
  final DateTime timestamp;

  LiveOrderStatusUpdate({
    required this.orderId,
    required this.newStatus,
    required this.previousStatus,
    required this.timestamp,
  });

  factory LiveOrderStatusUpdate.fromMap(Map<String, dynamic> json) {
    return LiveOrderStatusUpdate(
      orderId: json['orderId'] ?? '',
      newStatus: json['newStatus'] ?? '',
      previousStatus: json['previousStatus'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
