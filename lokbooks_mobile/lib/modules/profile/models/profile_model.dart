
class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String cpf;
  final DateTime? birthDate;
  final String phone;
  final String address;
  final bool admin;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.cpf,
    required this.birthDate,
    required this.phone,
    required this.address,
    required this.admin,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      cpf: json['cpf']?.toString() ?? '',
      birthDate: DateTime.tryParse(
        json['birthDate']?.toString() ?? '',
      ),
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      admin: json['admin'] == true,
    );
  }

  String get formattedCpf {
    final digits = cpf.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 11) {
      return cpf;
    }

    return '${digits.substring(0, 3)}.'
        '${digits.substring(3, 6)}.'
        '${digits.substring(6, 9)}-'
        '${digits.substring(9)}';
  }

  String get formattedPhone {
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) '
          '${digits.substring(2, 7)}-${digits.substring(7)}';
    }

    if (digits.length == 10) {
      return '(${digits.substring(0, 2)}) '
          '${digits.substring(2, 6)}-${digits.substring(6)}';
    }

    return phone;
  }

  ProfileModel copyWith({
    String? name,
    String? phone,
    String? address,
  }) {
    return ProfileModel(
      id: id,
      name: name ?? this.name,
      email: email,
      cpf: cpf,
      birthDate: birthDate,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      admin: admin,
    );
  }
}
