
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primary,
      centerTitle: true,
      title: Image.asset(
        'assets/images/lokbooks.png',
        height: 38,
        fit: BoxFit.contain,
      ),
    );
  }
}
