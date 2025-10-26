import 'package:boole_apps/features/culture/presentation/provider/culture_provider.dart';
import 'package:boole_apps/features/culture/presentation/provider/culture_state.dart';
import 'package:boole_apps/features/culture/presentation/screens/widgets/culture_detail_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CultureDetailScreen extends StatefulWidget {
  final String id;

  const CultureDetailScreen({super.key, required this.id});

  @override
  State<CultureDetailScreen> createState() => _CultureDetailScreenState();
}

class _CultureDetailScreenState extends State<CultureDetailScreen> {
  String? _lastErrorShownMessage;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      context.read<CultureProvider>().getCultureDetail(widget.id);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lastErrorShownMessage = null;
  }

  void _showErrorSnackbar(String message) {
    if (_lastErrorShownMessage == message) return;

    _lastErrorShownMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CultureProvider>(
        builder: (context, provider, child) {
          // Error state
          if (provider.state.status == CultureStatus.error) {
            final msg = provider.state.message ?? 'Unknown error occured';

            _showErrorSnackbar(msg);

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Caught an error',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      _lastErrorShownMessage = null; // Reset
                      provider.getCultureDetail(widget.id);
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.state.status == CultureStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          // Empty state
          if (provider.cultureDetail == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No detail available'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.getCultureDetail(widget.id),
                    child: Text('Load Data'),
                  ),
                ],
              ),
            );
          }

          // success state
          return CustomScrollView(
            slivers: <Widget>[
              CultureDetailAppBar(imageUrl: provider.cultureDetail!.imageUrl),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Province Name
                      _ProvinceNameWidget(),

                      const SizedBox(height: 12),
                      Divider(color: Theme.of(context).colorScheme.outline),

                      // Cultural Description
                      _CulturalDescriptionWidget(),

                      _ContentSpacer(),

                      // Languages
                      _LanguagesWidget(),

                      _ContentSpacer(),

                      // Visitor Tips
                      Text(
                        'Visitor Tips: ',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Wrap(
                          spacing: 8,
                          children: provider.cultureDetail!.visitorTips
                              .map((tips) => Chip(label: Text(tips)))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ContentSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Divider(
          color: Theme.of(
            context,
          ).colorScheme.tertiary.withAlpha((0.3 * 255).round()),
        ),
      ],
    );
  }
}

class _ProvinceNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CultureProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          provider.cultureDetail!.province,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${provider.cultureDetail!.region} Region',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _CulturalDescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CultureProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cultural Description',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          provider.cultureDetail!.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }
}

class _LanguagesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CultureProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Local Languages :',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Wrap(
            spacing: 8,
            children: provider.cultureDetail!.localLanguages
                .map((local) => Chip(label: Text(local)))
                .toList(),
          ),
        ),
        Text(
          'Primary Languages :',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Chip(label: Text(provider.cultureDetail!.primaryLanguage)),
        ),
      ],
    );
  }
}
