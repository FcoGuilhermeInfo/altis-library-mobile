
import 'package:flutter/material.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/modules/auth/controllers/auth_controller.dart';
import 'package:lokbooks_mobile/modules/auth/models/login_request.dart';
import 'package:lokbooks_mobile/modules/auth/models/user_role.dart';
import 'package:lokbooks_mobile/modules/auth/services/auth_service.dart';
import 'package:lokbooks_mobile/modules/auth/services/remembered_email_service.dart';

class LoginForm extends StatefulWidget {
  final AuthController authController;

  const LoginForm({
    super.key,
    required this.authController,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rememberedEmailService = RememberedEmailService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _emailEdited = false;
  bool _rememberMeEdited = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
  }

  Future<void> _loadRememberedEmail() async {
    try {
      final email =
          await _rememberedEmailService.getRememberedEmail();

      if (!mounted || email == null) return;

      setState(() {
        if (!_emailEdited && _emailController.text.isEmpty) {
          _emailController.text = email;
        }

        if (!_rememberMeEdited) {
          _rememberMe = true;
        }
      });
    } catch (error) {
      debugPrint('Erro ao carregar o e-mail lembrado: $error');
    }
  }

  Future<void> _persistRememberedEmail(
    String email,
    bool rememberMe,
  ) async {
    try {
      if (rememberMe) {
        await _rememberedEmailService.saveEmail(email);
      } else {
        await _rememberedEmailService.clearEmail();
      }
    } catch (error) {
      debugPrint('Erro ao salvar a preferência de login: $error');
    }
  }

  String _rememberMeLabel(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;

    return switch (language) {
      'en' => 'Remember me',
      'es' => 'Recordarme',
      _ => 'Lembrar-me',
    };
  }

  Future<void> _submit() async {
    if (_isLoading || !_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final rememberMe = _rememberMe;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = LoginRequest(
        email: email,
        password: password,
      );

      final role = await widget.authController.login(request);

      await _persistRememberedEmail(email, rememberMe);

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      final message = switch (role) {
        UserRole.admin => l10n.loginAdminSuccess,
        UserRole.user => l10n.loginUserSuccess,
      };

      _showMessage(message);
    } on AuthException catch (error) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      final message = switch (error.error) {
        AuthError.invalidCredentials =>
          l10n.loginInvalidCredentials,
        AuthError.connectionError =>
          l10n.loginConnectionError,
        AuthError.serverError =>
          l10n.loginServerError,
      };

      _showMessage(message);
    } catch (_) {
      if (!mounted) return;

      _showMessage(
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            autofillHints: const [AutofillHints.email],
            onChanged: (_) {
              _emailEdited = true;
            },
            decoration: InputDecoration(
              hintText: l10n.loginEmail,
              prefixIcon: const Icon(Icons.mail_outline),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.loginEmailRequired;
              }

              final emailRegex = RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              );

              if (!emailRegex.hasMatch(value.trim())) {
                return l10n.loginEmailInvalid;
              }

              return null;
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: _passwordController,
            enabled: !_isLoading,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              hintText: l10n.loginPassword,
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
            onFieldSubmitted: (_) => _submit(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.loginPasswordRequired;
              }

              return null;
            },
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              SizedBox(
                width: 30,
                height: 32,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                            _rememberMeEdited = true;
                          });
                        },
                  activeColor: const Color(0xFF1976D2),
                  checkColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFF808080),
                    width: 1.2,
                  ),
                  materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _rememberMe = !_rememberMe;
                            _rememberMeEdited = true;
                          });
                        },
                  child: Text(
                    _rememberMeLabel(context),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(l10n.loginSubmit),
          ),
        ],
      ),
    );
  }
}
