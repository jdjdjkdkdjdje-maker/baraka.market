import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String phone;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatar;
  final String? gender;
  final String? birthDate;
  final String role;
  final bool isActive;
  final bool isVerified;
  final String language;
  final String? lastLoginAt;
  final String createdAt;

  const UserModel({
    required this.id,
    required this.phone,
    this.firstName,
    this.lastName,
    this.email,
    this.avatar,
    this.gender,
    this.birthDate,
    required this.role,
    required this.isActive,
    required this.isVerified,
    required this.language,
    this.lastLoginAt,
    required this.createdAt,
  });

  String get fullName {
    if (firstName == null && lastName == null) return phone;
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    if (firstName != null) return firstName![0].toUpperCase();
    return phone.substring(phone.length - 2);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] as String?,
      role: json['role'] as String? ?? 'CUSTOMER',
      isActive: json['isActive'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? false,
      language: json['language'] as String? ?? 'UZ',
      lastLoginAt: json['lastLoginAt'] as String?,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'phone': phone, 'firstName': firstName,
    'lastName': lastName, 'email': email, 'avatar': avatar,
    'gender': gender, 'birthDate': birthDate, 'role': role,
    'isActive': isActive, 'isVerified': isVerified,
    'language': language, 'lastLoginAt': lastLoginAt, 'createdAt': createdAt,
  };

  UserModel copyWith({
    String? firstName, String? lastName, String? email,
    String? avatar, String? gender, String? birthDate, String? language,
  }) => UserModel(
    id: id, phone: phone, role: role, isActive: isActive,
    isVerified: isVerified, createdAt: createdAt,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    avatar: avatar ?? this.avatar,
    gender: gender ?? this.gender,
    birthDate: birthDate ?? this.birthDate,
    language: language ?? this.language,
  );

  @override
  List<Object?> get props => [id, phone, firstName, lastName, email, role];
}
