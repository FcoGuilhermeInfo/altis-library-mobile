
import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Text(
        l10n.dashboardPlaceholder,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
