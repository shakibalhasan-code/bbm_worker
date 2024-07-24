class UserModel {
  final String fullName;
  final String email;
  final String imageUrl;
  final String phone;
  final String role;

  UserModel({
    required this.fullName,
    required this.email,
    required this.imageUrl,
    required this.phone,
    required this.role,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? '',
    );
  }
}
