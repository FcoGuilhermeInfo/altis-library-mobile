
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

enum ProfileAction {
  profile,
  language,
  logout,
}

class ProfileMenu extends StatelessWidget {
  final String? userName;
  final String roleLabel;
  final ValueChanged<ProfileAction> onSelected;

  const ProfileMenu({
    super.key,
    this.userName,
    required this.roleLabel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final displayName = userName != null &&
            userName!.trim().isNotEmpty
        ? userName!.trim()
        : roleLabel;

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
          height: 95,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 45,
                ),
                const SizedBox(height: 6),
                Text(
                  displayName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
  