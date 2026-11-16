
import 'package:flutter/material.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/widgets/app_header.dart';
import 'package:lokbooks_mobile/modules/auth/presentation/widgets/reset_password_form.dart';

class ResetPasswordPage extends StatelessWidget {
  final String token;

  const ResetPasswordPage({
    super.key,
    required this.token,
  });

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Expanded(
                    child: Text(
                      l10n.resetPasswordTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 42),
              ResetPasswordForm(
                token: token,
                onPasswordReset: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
