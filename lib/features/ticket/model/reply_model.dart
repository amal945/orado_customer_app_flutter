class Reply {
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isAdmin;

  Reply({
    required this.sender,
    required this.message,
    required this.timestamp,
    this.isAdmin = false,
  });
}