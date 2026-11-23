import 'package:cloud_firestore/cloud_firestore.dart';
class Customer {
  final String uid;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String role;
  final bool isActive;
  final String installationId;
  final Map<String, dynamic> deviceInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Customer({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.isActive,
    required this.installationId,
    required this.deviceInfo,
    this.createdAt,
    this.updatedAt,
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
      'deviceInfo': deviceInfo,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      uid: map['uid'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String?,
      role: map['role'] as String? ?? 'customer',
      isActive: map['isActive'] as bool? ?? true,
      installationId: map['installationId'] as String,
      deviceInfo: Map<String, dynamic>.from(
        map['deviceInfo'] as Map? ?? {},
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}