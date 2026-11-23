
import 'package:shared_preferences/shared_preferences.dart';

class RememberedEmailService {
  static const String _emailKey = 'remembered_login_email';

  Future<String?> getRememberedEmail() async {
    final preferences = await SharedPreferences.getInstance();

    final email = preferences.getString(_emailKey);

    if (email == null || email.trim().isEmpty) {
      return null;
    }

    return email;
  }

  Future<void> saveEmail(String email) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _emailKey,
      email.trim(),
    );
  }

  Future<void> clearEmail() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_emailKey);
  }
}
