
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../models/profile_model.dart';
import '../../services/profile_service.dart';

enum ProfileSaveResult {
  personal,
  password,
  both,
}

class EditProfileDialog extends StatefulWidget {
  final ProfileModel profile;
  final AuthController authController;

  const EditProfileDialog({
    super.key,
    required this.profile,
    required this.authController,
  });

  @override
  State<EditProfileDialog> createState() =>
      _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _profileService = ProfileService();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSaving = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _personalSavedDuringDialog = false;

  String? _error;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.profile.name,
    );

    _phoneController = TextEditingController(
      text: widget.profile.phone.replaceAll(
        RegExp(r'\D'),
        '',
      ),
    );

    _addressController = TextEditingController(
      text: widget.profile.address,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  InputDecoration _decoration({
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFE8E8E8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      isDense: true,
      suffixIcon: readOnly
          ? const Icon(
              Icons.lock_outline,
              size: 19,
              color: Color(0xFF555555),
            )
          : suffixIcon,
    );
  }

  Widget _field({
    required String label,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF171717),
            ),
          ),
          const SizedBox(height: 7),
          child,
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.registerRequired;
    }

    return null;
  }

  bool get _wantsPasswordChange {
    return _currentPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty;
  }

  String? _validateCurrentPassword(String? value) {
    if (!_wantsPasswordChange) return null;

    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return l10n.profileCurrentPasswordRequired;
    }

    return null;
  }

  String? _validateNewPassword(String? value) {
    if (!_wantsPasswordChange) return null;

    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return l10n.profileNewPasswordRequired;
    }

    if (value.length < 8 || value.length > 15) {
      return l10n.profilePasswordLength;
    }

    if (value == _currentPasswordController.text) {
      return l10n.profilePasswordMustDiffer;
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!_wantsPasswordChange) return null;

    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return l10n.profileConfirmPasswordRequired;
    }

    if (value != _newPasswordController.text) {
      return l10n.profilePasswordMismatch;
    }

    return null;
  }

  String _formatBirthDate() {
    final date = widget.profile.birthDate;

    if (date == null) return '-';

    final language = Localizations.localeOf(context).languageCode;

    return DateFormat(
      language == 'en' ? 'MM/dd/yyyy' : 'dd/MM/yyyy',
    ).format(date);
  }

  bool get _hasPersonalChanges {
    final profile =
        widget.authController.profile ?? widget.profile;

    return _nameController.text.trim() != profile.name ||
        _phoneController.text.replaceAll(
              RegExp(r'\D'),
              '',
            ) !=
            profile.phone.replaceAll(RegExp(r'\D'), '') ||
        _addressController.text.trim() != profile.address;
  }

  String _requestErrorMessage(
    ProfileRequestException exception, {
    required bool password,
  }) {
    final l10n = AppLocalizations.of(context)!;

    if (exception.statusCode == 401) {
      return l10n.profileUnauthorized;
    }

    if (exception.statusCode == 403) {
      return l10n.profileForbidden;
    }

    if (exception.statusCode == 400 ||
        exception.statusCode == 409 ||
        exception.statusCode == 422) {
      return password
          ? l10n.profilePasswordError
          : l10n.profileInvalidData;
    }

    if (exception.statusCode == null) {
      return l10n.profileConnectionError;
    }

    return l10n.profileSaveError;
  }

  Future<void> _save() async {
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final hasPersonalChanges = _hasPersonalChanges;
    final hasPasswordChanges = _wantsPasswordChange;

    if (!hasPersonalChanges && !hasPasswordChanges) {
      if (_personalSavedDuringDialog) {
        Navigator.of(context).pop(ProfileSaveResult.personal);
      } else {
        Navigator.of(context).pop();
      }
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    bool savingPassword = false;

    try {
      if (hasPersonalChanges) {
        final updated = await _profileService.updateMyProfile(
          name: _nameController.text,
          phone: _phoneController.text,
          address: _addressController.text,
        );

        widget.authController.updateProfile(updated);
        _personalSavedDuringDialog = true;
      }

      if (hasPasswordChanges) {
        savingPassword = true;

        await _profileService.changePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        );
      }

      if (!mounted) return;

      final result = hasPasswordChanges
          ? _personalSavedDuringDialog
              ? ProfileSaveResult.both
              : ProfileSaveResult.password
          : ProfileSaveResult.personal;

      Navigator.of(context).pop(result);
    } on ProfileRequestException catch (exception) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      final message = _requestErrorMessage(
        exception,
        password: savingPassword,
      );

      setState(() {
        _error = _personalSavedDuringDialog && savingPassword
            ? '${l10n.profilePartialSuccess} $message'
            : message;
      });
    } catch (_) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      setState(() {
        _error = _personalSavedDuringDialog && savingPassword
            ? '${l10n.profilePartialSuccess} ${l10n.profileUnexpectedError}'
            : l10n.profileUnexpectedError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
    required String autocompleteHint,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return _field(
      label: label,
      child: TextFormField(
        controller: controller,
        obscureText: !visible,
        enabled: !_isSaving,
        autocorrect: false,
        enableSuggestions: false,
        autofillHints: [autocompleteHint],
        decoration: _decoration(
          suffixIcon: IconButton(
            onPressed: _isSaving ? null : onToggle,
            tooltip: visible
                ? l10n.profileHidePassword
                : l10n.profileShowPassword,
            icon: Icon(
              visible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 21,
              color: const Color(0xFF555555),
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = widget.profile;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 54,
                      color: Color(0xFF242424),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.roleUser,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      tooltip: l10n.actionClose,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                _field(
                  label: l10n.registerName,
                  child: TextFormField(
                    controller: _nameController,
                    enabled: !_isSaving,
                    maxLength: 50,
                    textCapitalization: TextCapitalization.words,
                    decoration: _decoration().copyWith(
                      counterText: '',
                    ),
                    validator: _requiredValidator,
                  ),
                ),
                _field(
                  label: l10n.registerEmail,
                  child: TextFormField(
                    initialValue: profile.email,
                    readOnly: true,
                    decoration: _decoration(readOnly: true),
                  ),
                ),
                _field(
                  label: l10n.registerCpf,
                  child: TextFormField(
                    initialValue: profile.formattedCpf,
                    readOnly: true,
                    decoration: _decoration(readOnly: true),
                  ),
                ),
                _field(
                  label: l10n.registerBirthDate,
                  child: TextFormField(
                    initialValue: _formatBirthDate(),
                    readOnly: true,
                    decoration: _decoration(readOnly: true),
                  ),
                ),
                _field(
                  label: l10n.registerPhone,
                  child: TextFormField(
                    controller: _phoneController,
                    enabled: !_isSaving,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    decoration: _decoration(),
                    validator: (value) {
                      final requiredError =
                          _requiredValidator(value);

                      if (requiredError != null) {
                        return requiredError;
                      }

                      final digits = value!.replaceAll(
                        RegExp(r'\D'),
                        '',
                      );

                      if (digits.length != 10 &&
                          digits.length != 11) {
                        return l10n.profilePhoneInvalid;
                      }

                      return null;
                    },
                  ),
                ),
                _field(
                  label: l10n.registerAddress,
                  child: TextFormField(
                    controller: _addressController,
                    enabled: !_isSaving,
                    textCapitalization:
                        TextCapitalization.sentences,
                    decoration: _decoration(),
                    validator: _requiredValidator,
                  ),
                ),
                const SizedBox(height: 10),
                _passwordField(
                  label: l10n.profileCurrentPassword,
                  controller: _currentPasswordController,
                  visible: _showCurrentPassword,
                  onToggle: () {
                    setState(() {
                      _showCurrentPassword =
                          !_showCurrentPassword;
                    });
                  },
                  validator: _validateCurrentPassword,
                  autocompleteHint: AutofillHints.password,
                ),
                _passwordField(
                  label: l10n.profileNewPassword,
                  controller: _newPasswordController,
                  visible: _showNewPassword,
                  onToggle: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                  validator: _validateNewPassword,
                  autocompleteHint: AutofillHints.newPassword,
                ),
                _passwordField(
                  label: l10n.profileConfirmPassword,
                  controller: _confirmPasswordController,
                  visible: _showConfirmPassword,
                  onToggle: () {
                    setState(() {
                      _showConfirmPassword =
                          !_showConfirmPassword;
                    });
                  },
                  validator: _validateConfirmPassword,
                  autocompleteHint: AutofillHints.newPassword,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 230,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        alignment: Alignment.center,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              l10n.profileSaveChanges,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
