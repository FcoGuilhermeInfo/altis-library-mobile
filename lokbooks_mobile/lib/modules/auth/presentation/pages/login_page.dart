
import 'package:flutter/material.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/widgets/app_header.dart';
import 'package:lokbooks_mobile/modules/auth/controllers/auth_controller.dart';
import 'package:lokbooks_mobile/modules/auth/presentation/widgets/login_form.dart';
import 'package:lokbooks_mobile/modules/auth/presentation/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController;

  const LoginPage({
    super.key,
    required this.authController,
  });

  Future<void> _openRegister(BuildContext context) async {
    final registered = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );

    if (!context.mounted || registered != true) return;

    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.registerSuccess)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const AppHeader(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.loginTitle,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 100),
                      LoginForm(
                        authController: authController,
                      ),
                      const SizedBox(height: 100),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          l10n.loginForgotPassword,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(l10n.loginNoAccount),
                          TextButton(
                            onPressed: () => _openRegister(context),
                            child: Text(
                              l10n.loginRegister,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
