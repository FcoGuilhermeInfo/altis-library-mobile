
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/theme/app_colors.dart';
import 'package:lokbooks_mobile/modules/publishers/models/publisher_model.dart';
import 'package:lokbooks_mobile/modules/publishers/models/publisher_request.dart';
import 'package:lokbooks_mobile/modules/publishers/services/publisher_service.dart';

class PublisherFormDialog extends StatefulWidget {
  final PublisherModel? publisher;

  const PublisherFormDialog({
    super.key,
    this.publisher,
  });

  @override
  State<PublisherFormDialog> createState() =>
      _PublisherFormDialogState();
}

class _PublisherFormDialogState extends State<PublisherFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _service = PublisherService();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _siteController;

  late final MaskTextInputFormatter _phoneMask;

  bool _isSaving = false;

  bool get _isEditing => widget.publisher != null;

  @override
  void initState() {
    super.initState();

    final publisher = widget.publisher;

    _nameController = TextEditingController(
      text: publisher?.name ?? '',
    );

    _emailController = TextEditingController(
      text: publisher?.email ?? '',
    );

    _phoneMask = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {'#': RegExp(r'[0-9]')},
    );

    _phoneController = TextEditingController(
      text: publisher?.formattedPhone ?? '',
    );

    _siteController = TextEditingController(
      text: publisher?.site ?? '',
    );
  }

  InputDecoration _decoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 21),
      filled: true,
      fillColor: const Color(0xFFE0E0E0),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 13,
        horizontal: 10,
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.registerRequired;
    }

    return null;
  }

  String _errorMessage(
    PublisherError error,
    AppLocalizations l10n,
  ) {
    return switch (error) {
      PublisherError.unauthorized => l10n.usersUnauthorized,
      PublisherError.forbidden => l10n.usersForbidden,
      PublisherError.invalidData => l10n.publishersInvalidData,
      PublisherError.conflict => l10n.publishersConflict,
      PublisherError.notFound => l10n.publishersNotFound,
      PublisherError.connection => l10n.loginConnectionError,
      PublisherError.server => l10n.publishersError,
    };
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  Future<void> _save() async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final request = PublisherRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.replaceAll(
          RegExp(r'\D'),
          '',
        ),
        site: _siteController.text.trim(),
      );

      if (_isEditing) {
        await _service.update(
          widget.publisher!.id,
          request,
        );
      } else {
        await _service.create(request);
      }

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } on PublisherException catch (error) {
      if (!mounted) return;

      _showError(
        _errorMessage(
          error.error,
          AppLocalizations.of(context)!,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      _showError(
        AppLocalizations.of(context)!.publishersError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _delete() async {
    if (!_isEditing || _isSaving) return;

    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.publishersDelete),
        content: Text(l10n.publishersDeleteConfirmation),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(false),
            child: Text(l10n.usersCancel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(true),
            child: Text(l10n.usersConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _service.delete(widget.publisher!.id);

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } on PublisherException catch (error) {
      if (!mounted) return;

      final message = error.error == PublisherError.conflict
          ? l10n.publishersDeleteConflict
          : _errorMessage(error.error, l10n);

      _showError(message);
    } catch (_) {
      if (!mounted) return;

      _showError(l10n.publishersError);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _dateInfo(
    BuildContext context,
    IconData icon,
    String label,
    DateTime date,
  ) {
    final language =
        Localizations.localeOf(context).languageCode;

    final pattern = language == 'en'
        ? 'MM/dd/yyyy, HH:mm'
        : 'dd/MM/yyyy, HH:mm';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 2),
        Icon(
          icon,
          color: Colors.blue,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                DateFormat(pattern).format(date),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _siteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final publisher = widget.publisher;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 480,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      _isEditing
                          ? l10n.publishersEditTitle
                          : l10n.publishersCreateTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      enabled: !_isSaving,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: _decoration(
                        l10n.registerName,
                        Icons.person_outline,
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      enabled: !_isSaving,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      enabled: !_isSaving,
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

                        final digits = value!.replaceAll(
                          RegExp(r'\D'),
                          '',
                        );

                        if (digits.length < 10 ||
                            digits.length > 11) {
                          return l10n.publishersInvalidPhone;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _siteController,
                      enabled: !_isSaving,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _save(),
                      decoration: _decoration(
                        l10n.publishersSite,
                        Icons.language,
                      ),
                      validator: (value) {
                        if (_required(value) != null) {
                          return l10n.registerRequired;
                        }

                        final site = value!.trim();
                        final uri = Uri.tryParse(
                          site.contains('://')
                              ? site
                              : 'https://$site',
                        );

                        if (uri == null ||
                            uri.host.isEmpty ||
                            !uri.host.contains('.') ||
                            !['http', 'https'].contains(uri.scheme)) {
                          return l10n.publishersInvalidSite;
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
              if (publisher != null) ...[
                const SizedBox(height: 25),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _dateInfo(
                        context,
                        Icons.calendar_today_outlined,
                        l10n.usersCreatedAt,
                        publisher.createdAt,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dateInfo(
                        context,
                        Icons.update,
                        l10n.usersUpdatedAt,
                        publisher.updatedAt,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 32),
              if (_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _delete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(),
                        ),
                        child: Text(
                          l10n.publishersDelete,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _saveButton(l10n),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: 170,
                  child: _saveButton(l10n),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveButton(AppLocalizations l10n) {
    return ElevatedButton(
      onPressed: _isSaving ? null : _save,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(),
      ),
      child: _isSaving
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              _isEditing
                  ? l10n.publishersEdit
                  : l10n.publishersCreate,
            ),
    );
  }
}
