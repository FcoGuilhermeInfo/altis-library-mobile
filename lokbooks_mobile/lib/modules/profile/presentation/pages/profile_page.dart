
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../models/profile_model.dart';
import '../widgets/edit_profile_dialog.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController;

  const ProfilePage({
    super.key,
    required this.authController,
  });

  String _formatBirthDate(
    BuildContext context,
    DateTime? date,
  ) {
    if (date == null) return '-';

    final language = Localizations.localeOf(context).languageCode;

    return DateFormat(
      language == 'en' ? 'MM/dd/yyyy' : 'dd/MM/yyyy',
    ).format(date);
  }

  Future<void> _openEditProfile(
    BuildContext context,
    ProfileModel profile,
  ) async {
    if (profile.admin) return;

    final result = await showDialog<ProfileSaveResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditProfileDialog(
        profile: profile,
        authController: authController,
      ),
    );

    if (!context.mounted || result == null) return;

    final l10n = AppLocalizations.of(context)!;

    final message = switch (result) {
      ProfileSaveResult.password => l10n.profilePasswordSuccess,
      ProfileSaveResult.personal => l10n.profileSaveSuccess,
      ProfileSaveResult.both => l10n.profileSaveSuccess,
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  Widget _profileField({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: Color(0xFF171717),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          SelectableText(
            value.trim().isEmpty ? '-' : value,
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentity(
    BuildContext context,
    ProfileModel profile,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.account_circle,
          size: 62,
          color: Color(0xFF242424),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: const TextStyle(
                  color: Color(0xFF171717),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                profile.admin
                    ? l10n.roleAdmin
                    : l10n.roleUser,
                style: const TextStyle(
                  color: Color(0xFF4D4D4D),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    ProfileModel profile,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIdentity(context, profile),
          if (!profile.admin) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => _openEditProfile(
                  context,
                  profile,
                ),
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                ),
                label: Text(l10n.profileEdit),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 30),
          _profileField(
            label: l10n.registerName,
            value: profile.name,
          ),
          _profileField(
            label: l10n.registerEmail,
            value: profile.email,
          ),
          if (!profile.admin) ...[
            _profileField(
              label: l10n.registerCpf,
              value: profile.formattedCpf,
            ),
            _profileField(
              label: l10n.registerBirthDate,
              value: _formatBirthDate(
                context,
                profile.birthDate,
              ),
            ),
            _profileField(
              label: l10n.registerPhone,
              value: profile.formattedPhone,
            ),
            _profileField(
              label: l10n.registerAddress,
              value: profile.address,
            ),
          ],
          _profileField(
            label: l10n.registerPassword,
            value: '********',
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback(
    BuildContext context,
    bool loading,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Icon(
            Icons.person_off_outlined,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.profileLoadError,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              authController.refreshProfile();
            },
            icon: const Icon(Icons.refresh),
            label: Text(l10n.usersRetry),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: authController,
      builder: (context, child) {
        final profile = authController.profile;
        final loading = authController.isLoadingProfile;

        return SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: authController.refreshProfile,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                22,
                16,
                32,
              ),
              children: [
                Text(
                  l10n.menuProfile,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 22),
                if (profile != null)
                  _buildProfileCard(context, profile)
                else
                  _buildFeedback(context, loading),
              ],
            ),
          ),
        );
      },
    );
  }
}
