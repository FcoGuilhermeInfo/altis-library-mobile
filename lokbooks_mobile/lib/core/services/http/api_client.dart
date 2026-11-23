
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://192.168.72.116:8080';

  static final http.Client client = http.Client();

  static Uri buildUri(String endpoint) {
    return Uri.parse(
      '$baseUrl/${endpoint.replaceFirst(RegExp(r"^/"), "")}',
    );
  }
}
