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

// Get Current Token
class GetTokenResponse {
  GetTokenResponse({
    required this.currentToken,
    required this.totalToken,
    required this.unlimited,
    required this.date,
  });

  final int currentToken;
  final int totalToken;
  final bool unlimited;
  final String? date;

  factory GetTokenResponse.fromJson(Map<String, dynamic> json) {
    return GetTokenResponse(
      currentToken: json['availableTokens'],
      totalToken: json['totalTokens'],
      unlimited: json['unlimited'],
      date: json['date'],
    );
  }
}

// Get Usage
class GetUsageResponse {
  GetUsageResponse({
    required this.name,
    required this.dailyTokens,
    required this.monthlyTokens,
    required this.annuallyTokens,
  });

  final String name;
  final int dailyTokens;
  final int monthlyTokens;
  final int annuallyTokens;

  factory GetUsageResponse.fromJson(Map<String, dynamic> json) {
    return GetUsageResponse(
      name: json['name'],
      dailyTokens: json['dailyTokens'],
      monthlyTokens: json['monthlyTokens'],
      annuallyTokens: json['annuallyTokens'],
    );
  }
}
