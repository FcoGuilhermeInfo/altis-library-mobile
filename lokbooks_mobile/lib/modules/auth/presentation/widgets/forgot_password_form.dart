
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/modules/auth/models/forgot_password_request.dart';
import 'package:lokbooks_mobile/modules/auth/services/password_reset_service.dart';

class ForgotPasswordForm extends StatefulWidget {
  final ValueChanged<String> onTokenReceived;

  const ForgotPasswordForm({
    super.key,
    required this.onTokenReceived,
  });

  @override
  State<ForgotPasswordForm> createState() =>
      _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _service = PasswordResetService();

  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  bool _isLoading = false;

  Future<void> _submit() async {
    if (_isLoading || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _service.forgotPassword(
        ForgotPasswordRequest(
          email: _emailController.text.trim(),
          cpf: _cpfMask.getUnmaskedText(),
        ),
      );

      if (!mounted) return;

      widget.onTokenReceived(token);
    } on PasswordResetException catch (error) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      final message = switch (error.error) {
        PasswordResetError.invalidCredentials =>
          l10n.forgotPasswordInvalidCredentials,
        PasswordResetError.invalidData =>
          l10n.forgotPasswordInvalidData,
        PasswordResetError.connection =>
          l10n.loginConnectionError,
        PasswordResetError.tooManyRequests =>
          l10n.passwordResetTooManyRequests,
        _ => l10n.loginServerError,
      };

      _showError(message);
    } catch (_) {
      if (!mounted) return;

      _showError(
        AppLocalizations.of(context)!.loginServerError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            enabled: !_isLoading,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: l10n.loginEmail,
              prefixIcon: const Icon(Icons.mail_outline),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.loginEmailRequired;
              }

              if (!RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              ).hasMatch(value.trim())) {
                return l10n.loginEmailInvalid;
              }

              return null;
            },
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _cpfController,
            enabled: !_isLoading,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [_cpfMask],
            onFieldSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: l10n.registerCpf,
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.registerRequired;
              }

              if (_cpfMask.getUnmaskedText().length != 11) {
                return l10n.registerInvalidCpf;
              }

              return null;
            },
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(l10n.forgotPasswordSubmit),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _isLoading
                ? null
                : () => Navigator.of(context).pop(),
            child: Text(l10n.registerBackToLogin),
          ),
        ],
      ),
    );
  }
}
