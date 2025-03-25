class LoginResponse {
  LoginResponse(this.accessToken, this.refreshToken, this.userId);

  final String accessToken;
  final String refreshToken;
  final String userId;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      json['access_token'],
      json['refresh_token'],
      json['user_id'],
    );
  }
}
