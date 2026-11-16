
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/theme/app_colors.dart';
import 'package:lokbooks_mobile/modules/publishers/models/publisher_model.dart';
import 'package:lokbooks_mobile/modules/publishers/models/publisher_page_result.dart';
import 'package:lokbooks_mobile/modules/publishers/presentation/widgets/publisher_form_dialog.dart';
import 'package:lokbooks_mobile/modules/publishers/services/publisher_service.dart';

class PublishersPage extends StatefulWidget {
  const PublishersPage({super.key});

  @override
  State<PublishersPage> createState() => _PublishersPageState();
}

class _PublishersPageState extends State<PublishersPage> {
  final _service = PublisherService();
  final _searchController = TextEditingController();

  Timer? _debounce;
  PublisherPageResult? _result;
  PublisherError? _error;

  int _currentPage = 1;
  int _requestId = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPublishers();
  }

  Future<void> _loadPublishers() async {
    final requestId = ++_requestId;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _service.findAll(
        search: _searchController.text.trim(),
        page: _currentPage,
      );

      if (!mounted || requestId != _requestId) return;

      setState(() {
        _result = result;
        _isLoading = false;
      });
    } on PublisherException catch (error) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _error = error.error;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _error = PublisherError.server;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 450),
      () {
        _currentPage = 1;
        _loadPublishers();
      },
    );
  }

  void _changePage(int page) {
    final totalPages = _result?.totalPages ?? 0;

    if (_isLoading || page < 1 || page > totalPages) return;

    _currentPage = page;
    _loadPublishers();
  }

  Future<void> _openForm([PublisherModel? publisher]) async {
    final changed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PublisherFormDialog(
        publisher: publisher,
      ),
    );

    if (!mounted || changed != true) return;

    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.publishersSuccess)),
      );

    _loadPublishers();
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

  Widget _publisherCard(PublisherModel publisher) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: const BorderSide(
          color: Color(0xFFE5E5E5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    publisher.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.publishersEdit,
                  onPressed: () => _openForm(publisher),
                  icon: const Icon(
                    Icons.edit_square,
                    color: AppColors.primary,
                    size: 23,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _infoRow(Icons.mail_outline, publisher.email),
            const SizedBox(height: 9),
            _infoRow(
              Icons.phone_outlined,
              publisher.formattedPhone,
            ),
            const SizedBox(height: 9),
            _infoRow(Icons.language, publisher.site),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _pagination(
    AppLocalizations l10n,
    PublisherPageResult result,
  ) {
    if (result.totalElements == 0) {
      return const SizedBox.shrink();
    }

    final start = (_currentPage - 1) * 10 + 1;
    final end = (_currentPage * 10).clamp(
      0,
      result.totalElements,
    );

    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          l10n.publishersShowing(
            start,
            end,
            result.totalElements,
          ),
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              tooltip: l10n.usersPrevious,
              onPressed: _currentPage > 1 && !_isLoading
                  ? () => _changePage(_currentPage - 1)
                  : null,
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              '${result.currentPage} / ${result.totalPages}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              tooltip: l10n.usersNext,
              onPressed: _currentPage < result.totalPages &&
                      !_isLoading
                  ? () => _changePage(_currentPage + 1)
                  : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResults(AppLocalizations l10n) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
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
            onPressed: _loadPublishers,
            child: Text(l10n.usersRetry),
          ),
        ],
      );
    }

    final result = _result;

    if (result == null || result.publishers.isEmpty) {
      return Center(
        child: Text(l10n.publishersEmpty),
      );
    }

    return Column(
      children: [
        ...result.publishers.map(_publisherCard),
        _pagination(l10n, result),
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
        onRefresh: _loadPublishers,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          children: [
            Text(
              l10n.menuPublishers,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      _debounce?.cancel();
                      _currentPage = 1;
                      _loadPublishers();
                    },
                    decoration: InputDecoration(
                      hintText: l10n.publishersSearch,
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openForm(),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.publishersNew),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildResults(l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
