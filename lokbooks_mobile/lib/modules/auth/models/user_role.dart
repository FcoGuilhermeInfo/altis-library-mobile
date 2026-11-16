
enum UserRole {
  admin,
  user;

  static UserRole fromString(String value) {
    return switch (value) {
      'ROLE_ADMIN' => UserRole.admin,
      'ROLE_USER' => UserRole.user,
      _ => throw const FormatException('Role inválida'),
    };
  }
}
