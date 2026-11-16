
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/theme/app_colors.dart';
import 'package:lokbooks_mobile/modules/users/models/user_model.dart';
import 'package:lokbooks_mobile/modules/users/models/user_page_result.dart';
import 'package:lokbooks_mobile/modules/users/presentation/widgets/user_details_dialog.dart';
import 'package:lokbooks_mobile/modules/users/services/user_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _service = UserService();
  final _searchController = TextEditingController();

  Timer? _debounce;
  UserPageResult? _result;
  UserServiceError? _error;

  int _currentPage = 1;
  int _requestId = 0;

  bool _isLoading = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final requestId = ++_requestId;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _service.findAll(
        search: _searchController.text.trim(),
        page: _currentPage,
        size: 10,
      );

      if (!mounted || requestId != _requestId) return;

      setState(() {
        _result = result;
        _isLoading = false;
      });
    } on UserServiceException catch (error) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _error = error.error;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _error = UserServiceError.server;
        _isLoading = false;
      });
    }
  }

  void _search(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 450),
      () {
        _currentPage = 1;
        _loadUsers();
      },
    );
  }

  void _changePage(int page) {
    final totalPages = _result?.totalPages ?? 0;

    if (_isLoading || _isUpdating) return;
    if (page < 1 || page > totalPages) return;

    _currentPage = page;
    _loadUsers();
  }

  void _showDetails(UserModel user) {
    showDialog<void>(
      context: context,
      builder: (context) => UserDetailsDialog(user: user),
    );
  }

  Future<void> _changeStatus(UserModel user) async {
    if (_isUpdating) return;

    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          user.active ? l10n.usersInactivate : l10n.usersActivate,
        ),
        content: Text(
          user.active
              ? l10n.usersConfirmInactivate
              : l10n.usersConfirmActivate,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.usersCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.usersConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      if (user.active) {
        await _service.inactivate(user.id);
      } else {
        await _service.activate(user.id);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.usersStatusUpdated)),
      );

      await _loadUsers();
    } on UserServiceException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage(error.error, l10n))),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.usersLoadError)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  String _errorMessage(
    UserServiceError error,
    AppLocalizations l10n,
  ) {
    return switch (error) {
      UserServiceError.unauthorized => l10n.usersUnauthorized,
      UserServiceError.forbidden => l10n.usersForbidden,
      UserServiceError.connection => l10n.loginConnectionError,
      UserServiceError.server => l10n.usersLoadError,
    };
  }

  Widget _tableHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              l10n.usersName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              l10n.usersCpf,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              l10n.registerEmail,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _userRow(UserModel user) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  user.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  user.formattedCpf,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              SizedBox(
                width: 32,
                child: PopupMenuButton<String>(
                  enabled: !_isUpdating,
                  tooltip: l10n.usersActions,
                  icon: const Icon(Icons.more_vert, size: 19),
                  padding: EdgeInsets.zero,
                  onSelected: (action) {
                    if (action == 'details') {
                      _showDetails(user);
                    } else if (action == 'status') {
                      _changeStatus(user);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'details',
                      child: Text(l10n.usersViewDetails),
                    ),
                    PopupMenuItem(
                      value: 'status',
                      child: Text(
                        user.active
                            ? l10n.usersInactivate
                            : l10n.usersActivate,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _pagination(AppLocalizations l10n) {
    final result = _result;

    if (result == null || result.totalElements == 0) {
      return const SizedBox.shrink();
    }

    final start = (_currentPage - 1) * 10 + 1;
    final end = (_currentPage * 10).clamp(0, result.totalElements);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Text(
            l10n.usersShowing(start, end, result.totalElements),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: _currentPage > 1
                    ? () => _changePage(_currentPage - 1)
                    : null,
                icon: const Icon(Icons.arrow_back, size: 16),
                label: Text(l10n.usersPrevious),
              ),
              Text(
                '$_currentPage / ${result.totalPages}',
                style: const TextStyle(fontSize: 11),
              ),
              TextButton(
                onPressed: _currentPage < result.totalPages
                    ? () => _changePage(_currentPage + 1)
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.usersNext),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _results(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Column(
        children: [
          Text(
            _errorMessage(_error!, l10n),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: _loadUsers,
            child: Text(l10n.usersRetry),
          ),
        ],
      );
    }

    final users = _result?.users ?? [];

    if (users.isEmpty) {
      return Center(child: Text(l10n.usersEmpty));
    }

    return Column(
      children: [
        _tableHeader(l10n),
        const Divider(height: 1),
        ...users.map(_userRow),
        _pagination(l10n),
      ],
    );
  }

  @override
  void dispose() {
    _requestId++;
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadUsers,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 18,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                l10n.menuUsers,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 20,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _search,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      _debounce?.cancel();
                      _currentPage = 1;
                      _loadUsers();
                    },
                    decoration: InputDecoration(
                      hintText: l10n.usersSearchHint,
                      hintStyle: const TextStyle(fontSize: 12),
                      suffixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFF1F1F1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 26),
                  _results(l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
