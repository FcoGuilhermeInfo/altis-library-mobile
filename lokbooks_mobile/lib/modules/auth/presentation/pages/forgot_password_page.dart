
import 'package:flutter/material.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/widgets/app_header.dart';
import 'package:lokbooks_mobile/modules/auth/presentation/pages/reset_password_page.dart';
import 'package:lokbooks_mobile/modules/auth/presentation/widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  Future<void> _openResetPassword(
    BuildContext context,
    String token,
  ) async {
    final success = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ResetPasswordPage(token: token),
      ),
    );

    if (!context.mounted || success != true) return;

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const AppHeader(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 24,
          ),
          child: Column(
            children: [
              Text(
                l10n.forgotPasswordTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.forgotPasswordDescription,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              ForgotPasswordForm(
                onTokenReceived: (token) {
                  _openResetPassword(context, token);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
