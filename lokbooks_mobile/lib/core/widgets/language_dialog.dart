
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

class LanguageDialog extends StatefulWidget {
  final Locale currentLocale;

  const LanguageDialog({
    super.key,
    required this.currentLocale,
  });

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  late Locale _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = widget.currentLocale;
  }

  Widget _languageOption({
    required String flag,
    required String label,
    required Locale locale,
  }) {
    final selected =
        _selectedLocale.languageCode == locale.languageCode;

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLocale = locale;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 4,
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: Colors.white,
                size: 21,
              ),
              const SizedBox(width: 12),
              Text(
                flag,
                style: const TextStyle(fontSize: 19),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: SizedBox(
        width: 300,
        height: 380,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.languageDialogTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              _languageOption(
                flag: '🇧🇷',
                label: 'Português',
                locale: const Locale('pt'),
              ),
              _languageOption(
                flag: '🇪🇸',
                label: 'Español',
                locale: const Locale('es'),
              ),
              _languageOption(
                flag: '🇺🇸',
                label: 'Inglês',
                locale: const Locale('en'),
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 145,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(_selectedLocale);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1099AC),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      l10n.languageDialogSave,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
