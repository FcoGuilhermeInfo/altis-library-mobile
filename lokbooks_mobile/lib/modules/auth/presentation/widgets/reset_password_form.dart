
import 'package:flutter/material.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/modules/auth/models/reset_password_request.dart';
import 'package:lokbooks_mobile/modules/auth/services/password_reset_service.dart';

class ResetPasswordForm extends StatefulWidget {
  final String token;
  final VoidCallback onPasswordReset;

  const ResetPasswordForm({
    super.key,
    required this.token,
    required this.onPasswordReset,
  });

  @override
  State<ResetPasswordForm> createState() =>
      _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _service = PasswordResetService();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_isLoading || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _service.resetPassword(
        ResetPasswordRequest(
          token: widget.token,
          newPassword: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );

      if (!mounted) return;

      widget.onPasswordReset();
    } on PasswordResetException catch (error) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      final message = switch (error.error) {
        PasswordResetError.invalidToken =>
          l10n.resetPasswordInvalidToken,
        PasswordResetError.invalidData =>
          l10n.resetPasswordInvalidData,
        PasswordResetError.connection =>
          l10n.loginConnectionError,
        PasswordResetError.tooManyRequests =>
          l10n.passwordResetTooManyRequests,
        _ => l10n.loginServerError,
      };

      _showError(message);
    } catch (_) {
      if (!mounted) return;

      _showError(AppLocalizations.of(context)!.loginServerError);
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
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            controller: _passwordController,
            enabled: !_isLoading,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(
              hintText: l10n.resetPasswordNewPassword,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.registerRequired;
              }

              if (value.length < 8 || value.length > 15) {
                return l10n.registerInvalidPassword;
              }

              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _confirmPasswordController,
            enabled: !_isLoading,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(
              hintText: l10n.registerConfirmPassword,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        });
                      },
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.registerRequired;
              }

              if (value != _passwordController.text) {
                return l10n.registerPasswordMismatch;
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
                : Text(l10n.resetPasswordSubmit),
          ),
        ],
      ),
    );
  }
}
