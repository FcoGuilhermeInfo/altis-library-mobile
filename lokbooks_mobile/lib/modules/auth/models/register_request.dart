
class RegisterRequest {
  final String name;
  final DateTime birthDate;
  final String cpf;
  final String phone;
  final String address;
  final String email;
  final String password;

  const RegisterRequest({
    required this.name,
    required this.birthDate,
    required this.cpf,
    required this.phone,
    required this.address,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final day = birthDate.day.toString().padLeft(2, '0');
    final month = birthDate.month.toString().padLeft(2, '0');
    final year = birthDate.year.toString();

    return {
      'name': name,
      'birthDate': '$day/$month/$year',
      'cpf': cpf,
      'phone': phone,
      'address': address,
      'email': email,
      'password': password,
    };
  }
}
