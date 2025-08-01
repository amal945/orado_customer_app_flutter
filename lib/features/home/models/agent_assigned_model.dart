class AgentAssigned {
  final String orderId;
  final String agentId;
  final String fullName;
  final String phoneNumber;

  AgentAssigned({
    required this.orderId,
    required this.agentId,
    required this.fullName,
    required this.phoneNumber,
  });

  factory AgentAssigned.fromMap(Map<String, dynamic> json) {
    final agent = json['agent'];
    return AgentAssigned(
      orderId: json['orderId']?.toString() ?? '',
      agentId: agent?['agentId']?.toString() ?? '',
      fullName: agent?['fullName']?.toString() ?? '',
      phoneNumber: agent?['phoneNumber']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'agentId': agentId,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
  };
}
