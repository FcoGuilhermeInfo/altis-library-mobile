
class LoginResponse {
  final String userId;
  final String token;
  final String type;
  final int expiresIn;

  const LoginResponse({
    required this.userId,
    required this.token,
    required this.type,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginResponse(
      userId: json['user_id'] as String,
      token: json['token'] as String,
      type: json['type'] as String,
      expiresIn: json['expiresIn'] as int,
    );
  }
}
