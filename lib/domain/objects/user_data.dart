class UserData {
  UserData({
    required this.userId,
    required this.accessToken,
    required this.baseUrl,
  });

  String userId;
  String accessToken;
  String baseUrl;

  String get uniqueId => '$baseUrl-$userId';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserData && runtimeType == other.runtimeType && userId == other.userId;

  @override
  int get hashCode => userId.hashCode;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        userId: json['email'] ?? '',
        accessToken: json['access'],
        baseUrl: json['base_url'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'email': userId,
        'access': accessToken,
        'base_url': baseUrl,
      };
}

enum SubscriptionLevel { starter, medium, pro }
