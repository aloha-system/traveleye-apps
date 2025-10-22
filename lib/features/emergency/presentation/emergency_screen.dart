import 'package:boole_apps/features/emergency/presentation/provider/emergency_provider.dart';
import 'package:boole_apps/features/emergency/presentation/widgets/emergency_category_filter.dart';
import 'package:boole_apps/features/emergency/presentation/widgets/emergency_search_bar.dart';
import 'package:boole_apps/features/emergency/presentation/widgets/emergency_service_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  void initState() {
    super.initState();
    // Load services on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmergencyProvider>().loadAllServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Numbers'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<EmergencyProvider>().loadAllServices();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          const EmergencySearchBar(),

          // Category Filter
          const EmergencyCategoryFilter(),

          const SizedBox(height: 8),

          // Services List
          Expanded(
            child: Consumer<EmergencyProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                }

                if (provider.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.errorMessage ?? 'Something went wrong',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => provider.loadAllServices(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (provider.services.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No services found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.loadAllServices(),
                  color: Colors.red,
                  child: ListView.builder(
                    itemCount: provider.services.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return EmergencyServiceCard(
                        service: provider.services[index],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<EmergencyProvider>().loadPriorityServices();
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.star),
        label: const Text('Priority Services'),
      ),
    );
  }
}
