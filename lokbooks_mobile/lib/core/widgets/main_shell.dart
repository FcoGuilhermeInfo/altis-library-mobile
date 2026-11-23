
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../services/routes/app_router.dart';
import '../theme/app_colors.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/auth/models/user_role.dart';
import 'app_header.dart';
import 'language_dialog.dart';
import 'profile_menu.dart';

class MainShell extends StatefulWidget {
  final AuthController authController;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final Widget child;

  const MainShell({
    super.key,
    required this.authController,
    required this.locale,
    required this.onLocaleChanged,
    required this.child,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool _isLoggingOut = false;

  void _navigate(String route) {
    Navigator.of(context).pop();
    context.go(route);
  }

  Widget _menuItem({
    required String route,
    required IconData icon,
    required String title,
    required String currentPath,
  }) {
    final selected = currentPath == route;

    return ListTile(
      selected: selected,
      selectedTileColor: const Color(0xFF327A86),
      leading: Icon(
        icon,
        color: Colors.white,
        size: 25,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w300,
        ),
      ),
      onTap: () => _navigate(route),
    );
  }

  void _openProfile() {
    context.go(AppRoutes.profile);
  }

  Future<void> _changeLanguage() async {
    final selected = await showDialog<Locale>(
      context: context,
      builder: (_) => LanguageDialog(
        currentLocale: widget.locale,
      ),
    );

    if (!mounted || selected == null) return;

    widget.onLocaleChanged(selected);
  }

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await widget.authController.logout();
    } catch (_) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.logoutError),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  void _handleProfileAction(ProfileAction action) {
    switch (action) {
      case ProfileAction.profile:
        _openProfile();

      case ProfileAction.language:
        _changeLanguage();

      case ProfileAction.logout:
        _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isAdmin =
        widget.authController.role == UserRole.admin;

    final roleLabel = isAdmin
        ? l10n.roleAdmin
        : l10n.roleUser;

    final currentPath =
        GoRouterState.of(context).uri.path;

    return Scaffold(
      appBar: AppHeader(
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: l10n.menuOpen,
            onPressed: () =>
                Scaffold.of(context).openDrawer(),
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 29,
            ),
          ),
        ),
        actions: [
          ListenableBuilder(
            listenable: widget.authController,
            builder: (context, child) => ProfileMenu(
              userName: widget.authController.userName,
              roleLabel: roleLabel,
              onSelected: _handleProfileAction,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        width: 265,
        backgroundColor: AppColors.primary,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 110,
                width: double.infinity,
                color: AppColors.primary,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/lokbooks.png',
                  height: 58,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Container(
                  color: const Color(0xFF105864),
                  child: ListView(
                    padding: const EdgeInsets.only(top: 12),
                    children: [
                      _menuItem(
                        route: AppRoutes.dashboard,
                        icon: Icons.home,
                        title: l10n.menuDashboard,
                        currentPath: currentPath,
                      ),
                      if (isAdmin) ...[
                        const SizedBox(height: 8),
                        _menuItem(
                          route: AppRoutes.loans,
                          icon: Icons.handshake,
                          title: l10n.menuLoans,
                          currentPath: currentPath,
                        ),
                        _menuItem(
                          route: AppRoutes.users,
                          icon: Icons.people,
                          title: l10n.menuUsers,
                          currentPath: currentPath,
                        ),
                        _menuItem(
                          route: AppRoutes.publishers,
                          icon: Icons.business,
                          title: l10n.menuPublishers,
                          currentPath: currentPath,
                        ),
                        _menuItem(
                          route: AppRoutes.books,
                          icon: Icons.menu_book,
                          title: l10n.menuBooks,
                          currentPath: currentPath,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: widget.child,
    );
  }
}
