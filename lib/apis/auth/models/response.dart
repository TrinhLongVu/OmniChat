// Login & Register
class AuthenticationResponse {
  AuthenticationResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  final String accessToken;
  final String refreshToken;
  final String userId;

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      userId: json['user_id'],
    );
  }
}

// Get Current User
class GetMeResponse {
  GetMeResponse({
    required this.id,
    required this.email,
    required this.username,
    required this.roles,
  });

  final String id;
  final String email;
  final String username;
  final List<String> roles;

  factory GetMeResponse.fromJson(Map<String, dynamic> json) {
    return GetMeResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      roles:
          (json['roles'] as List<dynamic>)
              .map((role) => role as String)
              .toList(),
    );
  }
}
// Refresh
