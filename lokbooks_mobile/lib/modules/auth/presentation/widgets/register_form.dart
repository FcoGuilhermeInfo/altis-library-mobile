
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/modules/auth/models/register_request.dart';
import 'package:lokbooks_mobile/modules/auth/services/register_service.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onRegistered;

  const RegisterForm({
    super.key,
    required this.onRegistered,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _registerService = RegisterService();

  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final _dateMask = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  String _datePattern = 'dd/MM/yyyy';
  String? _previousDatePattern;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locale = Localizations.localeOf(context);

    final newPattern = locale.languageCode == 'en'
        ? 'MM/dd/yyyy'
        : 'dd/MM/yyyy';

    if (_previousDatePattern != null &&
        _previousDatePattern != newPattern &&
        _birthDateController.text.isNotEmpty) {
      try {
        final date = DateFormat(
          _previousDatePattern!,
        ).parseStrict(_birthDateController.text);

        _birthDateController.text = DateFormat(
          newPattern,
        ).format(date);
      } on FormatException {
        _birthDateController.clear();
      }
    }

    _datePattern = newPattern;
    _previousDatePattern = newPattern;
  }

  InputDecoration _decoration(
    String hint,
    IconData icon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14),
      prefixIcon: Icon(icon, size: 21),
      suffixIcon: suffixIcon,
      filled: true,
      border: InputBorder.none,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 9,
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 44,
        minHeight: 40,
      ),
      suffixIconConstraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
      constraints: const BoxConstraints(
        minHeight: 40,
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.registerRequired;
    }

    return null;
  }

  DateTime? _parseBirthDate() {
    try {
      final date = DateFormat(
        _datePattern,
      ).parseStrict(_birthDateController.text);

      final today = DateTime.now();

      if (date.isBefore(DateTime(1900)) ||
          date.isAfter(today)) {
        return null;
      }

      return date;
    } on FormatException {
      return null;
    }
  }

  Future<void> _selectBirthDate() async {
    if (_isLoading) return;

    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _parseBirthDate() ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: now,
      initialDatePickerMode: DatePickerMode.year,
    );

    if (selectedDate == null || !mounted) return;

    setState(() {
      _birthDateController.text = DateFormat(
        _datePattern,
      ).format(selectedDate);
    });
  }

  Future<void> _submit() async {
    if (_isLoading || !_formKey.currentState!.validate()) {
      return;
    }

    final birthDate = _parseBirthDate();

    if (birthDate == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = RegisterRequest(
        name: _nameController.text.trim(),
        birthDate: birthDate,
        cpf: _cpfMask.getUnmaskedText(),
        phone: _phoneMask.getUnmaskedText(),
        address: _addressController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await _registerService.register(request);

      if (!mounted) return;

      widget.onRegistered();
    } on RegisterException catch (error) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      final message = switch (error.error) {
        RegisterError.invalidData =>
          l10n.registerInvalidData,
        RegisterError.forbidden =>
          l10n.registerForbidden,
        RegisterError.conflict =>
          l10n.registerConflict,
        RegisterError.connection =>
          l10n.loginConnectionError,
        RegisterError.server =>
          l10n.registerServerError,
      };

      _showMessage(message);
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        AppLocalizations.of(context)!.registerServerError,
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
    _nameController.dispose();
    _birthDateController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
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
            controller: _nameController,
            enabled: !_isLoading,
            style: const TextStyle(fontSize: 14),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: _decoration(
              l10n.registerName,
              Icons.person_outline,
            ),
            validator: _required,
          ),
          const SizedBox(height: 11),
          TextFormField(
            controller: _birthDateController,
            enabled: !_isLoading,
            style: const TextStyle(fontSize: 14),
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.next,
            inputFormatters: [_dateMask],
            decoration: _decoration(
              '${l10n.registerBirthDate} (${_datePattern.toLowerCase()})',
              Icons.calendar_month_outlined,
              suffixIcon: IconButton(
                onPressed: _isLoading ? null : _selectBirthDate,
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  size: 19,
                ),
              ),
            ),
            validator: (value) {
              if (_required(value) != null) {
                return l10n.registerRequired;
              }

              if (_parseBirthDate() == null) {
                return l10n.registerInvalidDate;
              }

              return null;
            },
          ),
          const SizedBox(height: 11),
          TextFormField(
            controller: _cpfController,
            enabled: !_isLoading,
            style: const TextStyle(fontSize: 14),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [_cpfMask],
            decoration: _decoration(
              l10n.registerCpf,
              Icons.badge_outlined,
            ),
            validator: (value) {
              if (_required(value) != null) {
                return l10n.registerRequired;
              }

              if (_cpfMask.getUnmaskedText().length != 11) {
                return l10n.registerInvalidCpf;
              }

              return null;
            },
          ),
          const SizedBox(height: 11),
          TextFormField(
            controller: _phoneController,
            enabled: !_isLoading,
            style: const TextStyle(fontSize: 14),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [_phoneMask],
            decoration: _decoration(
              l10n.registerPhone,
              Icons.phone_outlined,
            ),
            validator: (value) {
              if (_required(value) != null) {
                return l10n.registerRequired;
              }

              if (_phoneMask.getUnmaskedText().length != 11) {
                return l10n.registerInvalidPhone;
              }

              return null;
            },
          ),
          const SizedBox(height: 11),
          TextFormField(
            controller: _addressController,
            enabled: !_isLoading,
            style: const TextStyle(fontSize: 14),
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            decoration: _decoration(
              l10n.registerAddress,
              Icons.location_on_outlined,
            ),
            validator: _required,
          ),
          const SizedBox(height: 11),
          TextFormField(
            controller: _emailController,
            enabled: !_isLoading,
            style: const TextStyle(fontSize: 14),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            decoration: _decoration(
              l10n.registerEmail,
              Icons.mail_outline,
            ),
            validator: (value) {
              if (_required(value) != null) {
                return l10n.registerRequired;
              }

              if (!RegExp(
                r'^[A-Za-z0-9._%+-]+@gmail\.com$',
              ).hasMatch(value!.trim())) {
                return l10n.registerInvalidEmail;
              }

              return null;
            },
          ),
          const SizedBox(height: 11),
          TextFormField(
            controller: _passwordController,
            enabled: !_isLoading,
            style: const TextStyle(fontSize: 14),
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            decoration: _decoration(
              l10n.registerPassword,
              Icons.key_outlined,
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
                  size: 19,
                ),
              ),
            ),
            validator: (value) {
              if (_required(value) != null) {
                return l10n.registerRequired;
              }

              if (value!.length < 8 || value.length > 15) {
                return l10n.registerInvalidPassword;
              }

              return null;
            },
          ),
          const SizedBox(height: 11),
          TextFormField(
            controller: _confirmPasswordController,
            enabled: !_isLoading,
            style: const TextStyle(fontSize: 14),
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            decoration: _decoration(
              l10n.registerConfirmPassword,
              Icons.key_outlined,
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
                  size: 19,
                ),
              ),
            ),
            validator: (value) {
              if (_required(value) != null) {
                return l10n.registerRequired;
              }

              if (value != _passwordController.text) {
                return l10n.registerPasswordMismatch;
              }

              return null;
            },
          ),
          const SizedBox(height: 20),
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
                : Text(l10n.registerSubmit),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _isLoading
                ? null
                : () => Navigator.of(context).pop(),
            child: Text(
              l10n.registerBackToLogin,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
