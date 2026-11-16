
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/auth/models/user_role.dart';
import '../../modules/books/presentation/pages/books_page.dart';
import '../../modules/home/presentation/pages/dashboard_page.dart';
import '../../modules/loans/presentation/pages/loans_page.dart';
import '../../modules/publishers/presentation/pages/publishers_page.dart';
import '../../modules/users/presentation/pages/users_page.dart';
import 'app_header.dart';
import 'language_dialog.dart';
import 'profile_menu.dart';

enum AdminSection {
  dashboard,
  loans,
  users,
  publishers,
  books,
}

class MainShell extends StatefulWidget {
  final AuthController authController;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  const MainShell({
    super.key,
    required this.authController,
    required this.locale,
    required this.onLocaleChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  AdminSection _selectedSection = AdminSection.dashboard;
  bool _isLoggingOut = false;

  void _selectSection(AdminSection section) {
    Navigator.of(context).pop();

    setState(() {
      _selectedSection = section;
    });
  }

  Widget _menuItem({
    required AdminSection section,
    required IconData icon,
    required String title,
  }) {
    final selected = _selectedSection == section;

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
      onTap: () => _selectSection(section),
    );
  }

  Future<void> _showProfile() async {
    final l10n = AppLocalizations.of(context)!;

    final roleLabel = switch (widget.authController.role) {
      UserRole.admin => l10n.roleAdmin,
      UserRole.user => l10n.roleUser,
      null => '',
    };

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.menuProfile),
        content: Text(roleLabel),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(),
            child: Text(l10n.actionClose),
          ),
        ],
      ),
    );
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
        SnackBar(content: Text(l10n.logoutError)),
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
        _showProfile();
      case ProfileAction.language:
        _changeLanguage();
      case ProfileAction.logout:
        _logout();
    }
  }

  Widget _buildContent(
    AppLocalizations l10n,
    bool isAdmin,
  ) {
    if (!isAdmin) {
      return const DashboardPage();
    }

    return switch (_selectedSection) {
      AdminSection.dashboard => const DashboardPage(),
      AdminSection.loans => const LoansPage(),
      AdminSection.users => const UsersPage(),
      AdminSection.publishers => const PublishersPage(),
      AdminSection.books => const BooksPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAdmin = widget.authController.role == UserRole.admin;

    final roleLabel = isAdmin
        ? l10n.roleAdmin
        : l10n.roleUser;

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
          ProfileMenu(
            roleLabel: roleLabel,
            onSelected: _handleProfileAction,
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
                        section: AdminSection.dashboard,
                        icon: Icons.home,
                        title: l10n.menuDashboard,
                      ),
                      if (isAdmin) ...[
                        const SizedBox(height: 8),
                        _menuItem(
                          section: AdminSection.loans,
                          icon: Icons.handshake,
                          title: l10n.menuLoans,
                        ),
                        _menuItem(
                          section: AdminSection.users,
                          icon: Icons.people,
                          title: l10n.menuUsers,
                        ),
                        _menuItem(
                          section: AdminSection.publishers,
                          icon: Icons.business,
                          title: l10n.menuPublishers,
                        ),
                        _menuItem(
                          section: AdminSection.books,
                          icon: Icons.menu_book,
                          title: l10n.menuBooks,
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
      body: _buildContent(l10n, isAdmin),
    );
  }
}
