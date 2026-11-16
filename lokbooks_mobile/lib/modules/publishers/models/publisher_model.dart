
class PublisherModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String site;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PublisherModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.site,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PublisherModel.fromJson(Map<String, dynamic> json) {
    return PublisherModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      site: json['site'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
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
}
