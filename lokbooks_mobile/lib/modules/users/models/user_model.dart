
class UserModel {
  final String id;
  final String name;
  final DateTime birthDate;
  final String cpf;
  final String phone;
  final String address;
  final String email;
  final bool admin;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.cpf,
    required this.phone,
    required this.address,
    required this.email,
    required this.admin,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      cpf: json['cpf'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      admin: json['admin'] as bool,
      active: json['active'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  String get formattedCpf {
    final digits = cpf.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 11) return cpf;

    return '${digits.substring(0, 3)}.'
        '${digits.substring(3, 6)}.'
        '${digits.substring(6, 9)}-'
        '${digits.substring(9)}';
  }
}
