class ProfileData {
  ProfileData({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.profilePhotoPath,
  });

  String email;
  String firstName;
  String lastName;
  String profilePhotoPath;
  DateTime dateOfBirth;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileData &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          firstName == other.firstName &&
          lastName == other.lastName;

  @override
  int get hashCode => firstName.hashCode;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        profilePhotoPath: json['profile_photo_path'],
        dateOfBirth: json['date_of_birth'],
      );

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'profile_photo_path': profilePhotoPath,
        'date_of_birth': dateOfBirth,
      };
}
