<<<<<<< HEAD
=======
import 'package:flutter/material.dart';
>>>>>>> 4c8e7ef (feat(translate): implement translation feature with speech recognition and text-to-speech capabilities)
import 'package:boole_apps/app/app_router.dart';
import 'package:boole_apps/core/widgets/app_search_bar.dart';
import 'package:boole_apps/core/widgets/destination_card.dart';
import 'package:boole_apps/features/home/presentation/widgets/quick_actions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              AppSearchBar(
                onTap: () =>
                    Navigator.pushNamed(context, AppRouter.destination),
                onFilterTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Filter - Coming Soon!'),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildPopularDestinations(context),
              const SizedBox(height: 24),
              _buildEmergencySection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                  ),
                ),
                Text(
                  'BooLe',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.travel_explore,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Explore the beauty of Indonesia with a complete guide.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'title': 'Destination',
        'subtitle': 'Discover tourist destinations.',
        'icon': Icons.location_on,
        'color': Colors.blue,
      },
      {
        'title': 'Culture',
        'subtitle': 'Local etiquette guide.',
        'icon': Icons.people,
        'color': Colors.green,
      },
      {
        'title': 'Navigation',
        'subtitle': 'Routes & transportation.',
        'icon': Icons.directions,
        'color': Colors.orange,
      },
      {
        'title': 'Translator',
        'subtitle': 'EN ↔ ID',
        'icon': Icons.translate,
        'color': Colors.purple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Main Services',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        QuickActionsGrid(
          actions: actions
              .map(
                (a) => QuickActionCard(
                  title: a['title'] as String,
                  subtitle: a['subtitle'] as String,
                  icon: a['icon'] as IconData,
                  color: a['color'] as Color,
                  onTap: () {
<<<<<<< HEAD
                    if ((a['title'] as String) == 'Destination') {
                      Navigator.pushNamed(
                        context,
                        AppRouter.destination,
                        arguments: {'popularOnly': true},
                      );
=======
                    if (a['title'] == 'Penerjemah') {
                      Navigator.pushNamed(context, AppRouter.translate);
>>>>>>> 4c8e7ef (feat(translate): implement translation feature with speech recognition and text-to-speech capabilities)
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${a['title']} - Coming Soon!'),
<<<<<<< HEAD
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
=======
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
>>>>>>> 4c8e7ef (feat(translate): implement translation feature with speech recognition and text-to-speech capabilities)
                        ),
                      );
                    }
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPopularDestinations(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Popular Destination',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.destination,
                  arguments: {'popularOnly': true},
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('See More', overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DestinationHorizontalList(
          height: 200,
          items: _mockDestinations()
              .map(
                (d) => DestinationCard(
                  name: d['name']!,
                  location: d['location']!,
                  imageUrl: d['image']!,
                  rating: d['rating']!,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  List<Map<String, String>> _mockDestinations() => [
    {
      'name': 'Bali',
      'location': 'Dewata Island',
      'image':
          'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=300',
      'rating': '4.8',
    },
    {
      'name': 'Yogyakarta',
      'location': 'Gudeg City',
      'image':
          'https://images.unsplash.com/photo-1555993539-1732b0258235?w=300',
      'rating': '4.7',
    },
    {
      'name': 'Raja Ampat',
      'location': 'West Papua',
      'image':
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=300',
      'rating': '4.9',
    },
  ];

  Widget _buildEmergencySection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Emergency Services - Coming Soon!'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.errorContainer.withAlpha((0.1 * 255).round()),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.error.withAlpha((0.2 * 255).round()),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.error.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.emergency,
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergency services.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quick access to emergency numbers and healthcare services.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.error,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
