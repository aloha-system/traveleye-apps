import 'package:boole_apps/app/app_router.dart';
import 'package:boole_apps/core/widgets/destination_card.dart';
import 'package:boole_apps/features/culture/presentation/provider/culture_provider.dart';
import 'package:boole_apps/features/culture/presentation/provider/culture_state.dart';
import 'package:boole_apps/features/culture/presentation/screens/widgets/culture_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CultureScreen extends StatefulWidget {
  const CultureScreen({super.key});

  @override
  State<CultureScreen> createState() => _CultureScreenState();
}

class _CultureScreenState extends State<CultureScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CultureProvider>().getCulture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Culture',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CultureProvider>().getCulture();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CultureSearchBar(), _ResultBody()],
        ),
      ),
    );
  }
}

class _ResultBody extends StatefulWidget {
  const _ResultBody();

  @override
  State<_ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<_ResultBody> {
  String? _lastErrorShownMessage;

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
    return Expanded(
      child: Consumer<CultureProvider>(
        builder: (context, value, child) {
          // Error state
          if (value.state.status == CultureStatus.error) {
            final msg = value.state.message ?? 'Unknown error occurred';

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
                      value.getCulture();
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Loading state
          if (value.state.status == CultureStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          // Empty state
          if (value.cultureList == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No cultures available'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => value.getCulture(),
                    child: Text('Load Data'),
                  ),
                ],
              ),
            );
          }

          // Success state
          return RefreshIndicator(
            onRefresh: () => value.getCulture(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: value.cultureList!.length,
              itemBuilder: (context, index) {
                final cultureItem = value.cultureList![index];
                return DestinationCard(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.cultureDetail,
                      arguments: cultureItem.id,
                    );
                  },
                  name: cultureItem.province,
                  location: cultureItem.region,
                  imageUrl: cultureItem.imageUrl[1],
                  rating: '',
                );
              },
            ),
          );
        },
      ),
    );
  }
}
