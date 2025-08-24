class UserProfileModel {
  final String name, phone;

  UserProfileModel({
    required this.name,
    required this.phone,
  });

  static UserProfileModel fromJson(Map<String, dynamic> data) {
    return UserProfileModel(
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}
