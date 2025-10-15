import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boole_apps/core/widgets/destination_card.dart';
import 'package:boole_apps/features/destination/presentation/providers/destination_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _text = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    final c = context.read<DestinationProvider>();
    _text.text = c.keyword;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.initialSearchIfNeeded();
    });
  }

  @override
  void dispose() {
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = context.watch<DestinationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            tooltip: 'Clear filters',
            icon: const Icon(Icons.refresh),
            onPressed: () => c.clearAll(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _SearchInput(
                controller: _text,
                focusNode: _focus,
                onChanged: c.onKeywordChanged,
                onFilterTap: () => _openFilterSheet(context),
              ),
            ),
            const _QuickFilters(),
            Divider(
              height: 1,
              color: theme.dividerColor.withValues(alpha: 0.3),
            ),

            const Expanded(child: _ResultList()),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    final c = context.read<DestinationProvider>();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Lanjutan', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.sell, size: 18),
              const SizedBox(width: 8),
              const Text('Budget Maksimal'),
              const Spacer(),
              DropdownButton<int?>(
                value: c.maxBudget,
                items: const [
                  DropdownMenuItem(value: null, child: Text('Tanpa batas')),
                  DropdownMenuItem(value: 100000, child: Text('≤ 100k')),
                  DropdownMenuItem(value: 200000, child: Text('≤ 200k')),
                  DropdownMenuItem(value: 300000, child: Text('≤ 300k')),
                ],
                onChanged: (v) => c.setBudget(v),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.place, size: 18),
              const SizedBox(width: 8),
              const Text('Nearby (eksperimental)'),
              const Spacer(),
              Switch(value: c.nearbyOnly, onChanged: (_) => c.toggleNearby()),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.star_rounded, size: 18),
              const SizedBox(width: 8),
              const Text('Popular (≥ 4.7)'),
              const Spacer(),
              Switch(value: c.popularOnly, onChanged: (_) => c.togglePopular()),
            ]),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Terapkan'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// (helper widgets di bawah TIDAK perlu diubah: hanya tipe provider di context.* diganti ke SearchNotifier)

class _SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const _SearchInput({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withAlpha((0.2 * 255).round())),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: cs.onSurface.withAlpha((0.6 * 255).round())),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Cari destinasi wisata…',
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.filter_list, color: cs.onPrimary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickFilters extends StatelessWidget {
  const _QuickFilters();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<DestinationProvider>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Popular (≥ 4.7)'),
            selected: c.popularOnly,
            onSelected: (_) => c.togglePopular(),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Nearby'),
            selected: c.nearbyOnly,
            onSelected: (_) => c.toggleNearby(),
          ),
          const SizedBox(width: 8),
          _BudgetChip(
            selectedBudget: c.maxBudget,
            onSelected: (b) => c.setBudget(b),
          ),
        ],
      ),
    );
  }
}

class _BudgetChip extends StatelessWidget {
  final int? selectedBudget;
  final ValueChanged<int?> onSelected;
  const _BudgetChip({required this.selectedBudget, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int?>(
      onSelected: onSelected,
      itemBuilder: (context) => const <PopupMenuEntry<int?>>[
        PopupMenuItem(value: null, child: Text('No budget cap')),
        PopupMenuItem(value: 100000, child: Text('≤ 100k')),
        PopupMenuItem(value: 200000, child: Text('≤ 200k')),
        PopupMenuItem(value: 300000, child: Text('≤ 300k')),
      ],
      child: FilterChip(
        label: Text(selectedBudget == null ? 'Budget' : 'Budget: ≤ $selectedBudget'),
        selected: selectedBudget != null,
        onSelected: (_) {},
      ),
    );
  }
}


class _ResultList extends StatelessWidget {
  const _ResultList();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<DestinationProvider>();

    if (c.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (c.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text('An error occurred', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('${c.error}', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: () => c.retry(), child: const Text('Try Again')),
            ],
          ),
        ),
      );
    }

    if (c.results.isEmpty &&
        c.keyword.isEmpty &&
        !c.popularOnly &&
        !c.nearbyOnly &&
        c.maxBudget == null &&
        c.dateRange == null) {
      return const _EmptyHint();
    }

    if (c.results.isEmpty) {
      return const _NoResults();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: c.results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final it = c.results[i];
        return DestinationCard(
          name: it.name,
          location: it.location,
          imageUrl: it.imageUrl,
          rating: it.ratingText,
          width: double.infinity,
          height: 180,
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: it.id);
          },
        );
      },
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search, size: 48),
            const SizedBox(height: 12),
            Text('Cari destinasi', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Ketik nama tempat, kota, atau pakai filter Popular/Budget/Nearby.'),
          ],
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sentiment_dissatisfied, size: 48),
            const SizedBox(height: 12),
            Text('Tidak ada hasil', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Coba ubah kata kunci atau long-press tombol tanggal untuk menghapus rentang tanggal.'),
          ],
        ),
      ),
    );
  }
}
