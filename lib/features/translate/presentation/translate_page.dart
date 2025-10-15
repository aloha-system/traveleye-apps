import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boole_apps/features/translate/presentation/provider/translation_provider.dart';
import 'dart:async';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  late TextEditingController _textController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  void _syncControllerWithProvider(TranslationProvider provider) {
    if (_textController.text != provider.state.originalText) {
      _textController.text = provider.state.originalText;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged(String value, TranslationProvider provider) {
    _debounceTimer?.cancel();

    provider.updateOriginalText(value);

    if (value.isNotEmpty) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        provider.translateText(value);
      });
    } else {
      // Clear translation immediately if text is empty
      provider.clearTranslatedText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translator'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<TranslationProvider>(
        builder: (context, provider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _syncControllerWithProvider(provider);
          });
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLanguageSelector(context, provider),
                const SizedBox(height: 24),
                _buildInputSection(context, provider),
                const SizedBox(height: 16),
                _buildSwapButton(context, provider),
                const SizedBox(height: 16),
                _buildOutputSection(context, provider),
                const SizedBox(height: 24),
                _buildActionButtons(context, provider),
                if (provider.state.isError) ...[
                  const SizedBox(height: 16),
                  _buildErrorWidget(context, provider),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, TranslationProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildLanguageCard(
              context,
              _getLanguageName(provider.state.sourceLanguage),
              provider.state.sourceLanguage,
              true, // Source language is always selected
              () => provider.setSourceLanguage(provider.state.sourceLanguage),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildLanguageCard(
              context,
              _getLanguageName(provider.state.targetLanguage),
              provider.state.targetLanguage,
              true, // Target language is always selected
              () => provider.setTargetLanguage(provider.state.targetLanguage),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    String language,
    String code,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Text(
              language,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              code.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Colors.white.withOpacity(0.8)
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(BuildContext context, TranslationProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getLanguageName(provider.state.sourceLanguage),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: _textController,
            onChanged: (value) => _onTextChanged(value, provider),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: _getInputHint(provider.state.sourceLanguage),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              suffixIcon: provider.state.isListening
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.mic,
                        color: provider.state.isListening
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onPressed: provider.state.isListening
                          ? null
                          : () => provider.startListening(),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwapButton(BuildContext context, TranslationProvider provider) {
    return Center(
      child: GestureDetector(
        onTap: () {
          provider.swapLanguages();
          _textController.text = provider.state.originalText;
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.swap_vert,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildOutputSection(BuildContext context, TranslationProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getLanguageName(provider.state.targetLanguage),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: provider.state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Text(
                  provider.state.translatedText.isEmpty
                      ? _getOutputHint(provider.state.targetLanguage)
                      : provider.state.translatedText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: provider.state.translatedText.isEmpty
                        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, TranslationProvider provider) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: provider.state.translatedText.isEmpty
                ? null
                : () => provider.speakText(
                      provider.state.translatedText,
                      provider.state.targetLanguage,
                    ),
            icon: provider.state.isSpeaking
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.volume_up),
            label: Text(provider.state.isSpeaking ? 'Speaking...' : 'Listen'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: provider.state.originalText.isEmpty && provider.state.translatedText.isEmpty
                ? null
                : () {
                    provider.clearText();
                    _textController.clear();
                    _debounceTimer?.cancel();
                  },
            icon: const Icon(Icons.clear),
            label: const Text('Clear'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context, TranslationProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              provider.state.message ?? 'An error occurred',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'id':
        return 'Indonesian';
      default:
        return languageCode.toUpperCase();
    }
  }

  String _getInputHint(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'Type or speak text in English...';
      case 'id':
        return 'Ketik atau ucapkan teks dalam bahasa Indonesia...';
      default:
        return 'Type or speak text...';
    }
  }

  String _getOutputHint(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'Translation will appear here...';
      case 'id':
        return 'Terjemahan akan muncul di sini...';
      default:
        return 'Translation will appear here...';
    }
  }
}
