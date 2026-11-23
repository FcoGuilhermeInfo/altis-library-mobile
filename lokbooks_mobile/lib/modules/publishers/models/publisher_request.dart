
class PublisherRequest {
  final String name;
  final String email;
  final String phone;
  final String site;

  const PublisherRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.site,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'site': site,
    };
  }
}
