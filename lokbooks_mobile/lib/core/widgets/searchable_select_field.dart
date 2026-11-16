
import 'dart:async';

import 'package:flutter/material.dart';

class SearchResultPage<T> {
  final List<T> items;
  final int totalPages;

  const SearchResultPage({
    required this.items,
    required this.totalPages,
  });
}

class SearchableSelectField<T> extends StatefulWidget {
  final String label;
  final IconData icon;
  final String emptyMessage;
  final String errorMessage;
  final String retryLabel;
  final String previousLabel;
  final String nextLabel;
  final String? validationError;
  final String? initialText;
  final bool enabled;
  final Future<SearchResultPage<T>> Function(String search, int page)
      search;
  final String Function(T item) titleOf;
  final String Function(T item) subtitleOf;
  final bool Function(T item) canSelect;
  final ValueChanged<T?> onSelected;

  const SearchableSelectField({
    super.key,
    required this.label,
    required this.icon,
    required this.emptyMessage,
    required this.errorMessage,
    required this.retryLabel,
    required this.previousLabel,
    required this.nextLabel,
    required this.search,
    required this.titleOf,
    required this.subtitleOf,
    required this.canSelect,
    required this.onSelected,
    this.initialText,
    this.validationError,
    this.enabled = true,
  });

  @override
  State<SearchableSelectField<T>> createState() =>
      _SearchableSelectFieldState<T>();
}

class _SearchableSelectFieldState<T>
    extends State<SearchableSelectField<T>> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  Timer? _debounce;
  List<T> _items = [];

  int _page = 1;
  int _totalPages = 0;
  int _requestId = 0;

  bool _isOpen = false;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.initialText ?? '',
    );
  }

  Future<void> _load() async {
    final requestId = ++_requestId;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final result = await widget.search(
        _controller.text.trim(),
        _page,
      );

      if (!mounted || requestId != _requestId) return;

      setState(() {
        _items = result.items;
        _totalPages = result.totalPages;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _items = [];
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    _requestId++;

    widget.onSelected(null);

    setState(() {
      _page = 1;
      _items = [];
      _isOpen = true;
      _isLoading = true;
      _hasError = false;
    });

    _debounce = Timer(
      const Duration(milliseconds: 450),
      _load,
    );
  }

  void _toggleOptions() {
    _debounce?.cancel();

    if (_isOpen) {
      _requestId++;

      setState(() {
        _isOpen = false;
        _isLoading = false;
      });

      _focusNode.unfocus();
      return;
    }

    setState(() {
      _isOpen = true;
      _page = 1;
    });

    _load();
  }

  void _select(T item) {
    _debounce?.cancel();
    _requestId++;

    _controller.text = widget.titleOf(item);
    widget.onSelected(item);

    setState(() {
      _isOpen = false;
      _isLoading = false;
    });

    _focusNode.unfocus();
  }

  void _changePage(int page) {
    if (_isLoading || page < 1 || page > _totalPages) {
      return;
    }

    setState(() {
      _page = page;
    });

    _load();
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(widget.errorMessage),
            TextButton(
              onPressed: _load,
              child: Text(widget.retryLabel),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          widget.emptyMessage,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 205),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _items.length,
            separatorBuilder: (_, _) =>
                const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = _items[index];
              final selectable = widget.canSelect(item);

              return ListTile(
                dense: true,
                enabled: selectable,
                title: Text(
                  widget.titleOf(item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  widget.subtitleOf(item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: selectable
                    ? () => _select(item)
                    : null,
              );
            },
          ),
        ),
        if (_totalPages > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                tooltip: widget.previousLabel,
                onPressed: _page > 1
                    ? () => _changePage(_page - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '$_page / $_totalPages',
                style: const TextStyle(fontSize: 12),
              ),
              IconButton(
                tooltip: widget.nextLabel,
                onPressed: _page < _totalPages
                    ? () => _changePage(_page + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
      ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _requestId++;
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          onChanged: _onTextChanged,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) {
            _debounce?.cancel();

            setState(() {
              _isOpen = true;
              _page = 1;
            });

            _load();
          },
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: Icon(widget.icon, size: 21),
            suffixIcon: IconButton(
              tooltip: widget.label,
              onPressed: widget.enabled
                  ? _toggleOptions
                  : null,
              icon: Icon(
                _isOpen
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFE0E0E0),
            border: InputBorder.none,
            isDense: true,
            errorText: widget.validationError,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 14,
            ),
          ),
        ),
        if (_isOpen && widget.enabled)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFDADADA),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: _buildResults(),
          ),
      ],
    );
  }
}
