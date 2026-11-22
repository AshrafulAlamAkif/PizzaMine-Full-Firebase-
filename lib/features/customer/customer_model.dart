
class Customer {
  final String uid;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String role;
  final bool isActive;
  final String installationId;
  final String platform;
  final DateTime createdAt;

  const Customer({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.isActive,
    required this.installationId,
    required this.platform,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'isActive': isActive,
      'installationId': installationId,
      'platform': platform,
      'createdAt': createdAt,
    };
  }
}