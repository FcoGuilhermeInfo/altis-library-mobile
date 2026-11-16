
class ForgotPasswordRequest {
  final String email;
  final String cpf;

  const ForgotPasswordRequest({
    required this.email,
    required this.cpf,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'cpf': cpf,
    };
  }
}
