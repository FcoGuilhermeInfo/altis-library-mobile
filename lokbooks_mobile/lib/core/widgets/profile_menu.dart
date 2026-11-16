
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

enum ProfileAction {
  profile,
  language,
  logout,
}

class ProfileMenu extends StatelessWidget {
  final String roleLabel;
  final ValueChanged<ProfileAction> onSelected;

  const ProfileMenu({
    super.key,
    required this.roleLabel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<ProfileAction>(
      tooltip: l10n.menuProfile,
      onSelected: onSelected,
      color: AppColors.primary,
      elevation: 6,
      offset: const Offset(0, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: const BoxConstraints(
        minWidth: 215,
        maxWidth: 235,
      ),
      icon: const Icon(
        Icons.account_circle,
        color: Colors.white,
        size: 34,
      ),
      itemBuilder: (context) => [
        PopupMenuItem<ProfileAction>(
          enabled: false,
          height: 90,
          child: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 45,
                ),
                const SizedBox(height: 6),
                Text(
                  roleLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<ProfileAction>(
          value: ProfileAction.profile,
          child: Row(
            children: [
              const Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              const SizedBox(width: 18),
              Text(
                l10n.menuProfile,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<ProfileAction>(
          value: ProfileAction.language,
          child: Row(
            children: [
              const Icon(
                Icons.language,
                color: Colors.white,
              ),
              const SizedBox(width: 18),
              Text(
                l10n.menuChangeLanguage,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem<ProfileAction>(
          enabled: false,
          height: 75,
          child: SizedBox.shrink(),
        ),
        PopupMenuItem<ProfileAction>(
          value: ProfileAction.logout,
          child: Row(
            children: [
              const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              const SizedBox(width: 18),
              Text(
                l10n.menuLogout,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
