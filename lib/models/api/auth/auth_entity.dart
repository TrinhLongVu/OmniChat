class AuthEntity {
  AuthEntity(this.id, this.email, this.username, this.roles);

  final String id;
  final String email;
  final String username;
  final List<String> roles;

  factory AuthEntity.fromJson(Map<String, dynamic> json) {
    return AuthEntity(
      json['id'] as String,
      json['email'] as String,
      json['username'] as String,
      (json['roles'] as List<dynamic>).map((role) => role as String).toList(),
    );
  }
}
