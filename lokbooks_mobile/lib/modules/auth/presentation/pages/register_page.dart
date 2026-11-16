
import 'package:flutter/material.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/widgets/app_header.dart';
import 'package:lokbooks_mobile/modules/auth/presentation/widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const AppHeader(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 12,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 24,
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.registerTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 14),
                    RegisterForm(
                      onRegistered: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
