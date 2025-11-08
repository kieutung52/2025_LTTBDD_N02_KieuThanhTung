import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:frontend_flutter/core/models/dictionary/search_word_response.dart';
import 'package:frontend_flutter/core/services/dictionary_service.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/l10n/app_localizations.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  SearchWordResponse? _searchResult;
  bool _isLoading = false;
  String? _error;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _searchWord(query);
      } else {
        setState(() {
          _searchResult = null;
          _error = null;
          _hasSearched = false;
        });
      }
    });
  }

  Future<void> _searchWord(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _hasSearched = true;
    });

    final dictionaryService = context.read<DictionaryService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response = await dictionaryService.searchWord(query);
      if (!mounted) return;
      if (response.success && response.data != null) {
        setState(() {
          _searchResult = response.data;
          _isLoading = false;
        });
      } else {
        throw Exception(response.message ?? "Không tìm thấy từ");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
        _searchResult = null;
      });
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
              content: Text("Lỗi: ${e.toString()}"),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: l10n.searchVocabHint,
              prefixIcon: const Icon(LucideIcons.search, size: 20),
              suffixIcon: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 3),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: _buildResultWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _buildResultWidget(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
          child: Text(l10n.errorPrefix(_error!),
              style: const TextStyle(color: AppColors.error)));
    }

    if (_searchResult != null) {
      final result = _searchResult!;
      return Card(
        elevation: 2,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              result.vocabulary,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
            ),
            if (result.transcriptionUk != null)
              Text(l10n.transcriptionUK(result.transcriptionUk!),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 16)),
            if (result.transcriptionUs != null)
              Text(l10n.transcriptionUS(result.transcriptionUs!),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 16)),

            const Divider(height: 32),

            ...result.details.map((detail) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      label: Text(detail.vocabType.name.toUpperCase()),
                      backgroundColor: AppColors.lightBlue,
                      labelStyle: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500),
                      side: BorderSide.none,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      detail.meaning,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    if (detail.explanation != null)
                      Text(
                        detail.explanation!,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic),
                      ),
                    if (detail.exampleSentence != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.examplePrefix(detail.exampleSentence!),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ]
                  ],
                ),
              );
            }),
          ],
        ),
      );
    }

    if (_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.searchX, size: 64, color: AppColors.textDisabled),
            SizedBox(height: 16),
            Text(l10n.wordNotFoundTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(l10n.wordNotFoundSubtitle,
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.search, size: 64, color: AppColors.textDisabled),
          SizedBox(height: 16),
          Text(l10n.searchDictionaryTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Text(l10n.searchDictionarySubtitle,
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}