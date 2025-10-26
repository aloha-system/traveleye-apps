import 'package:boole_apps/features/emergency/presentation/provider/emergency_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmergencyCategoryFilter extends StatelessWidget {
  const EmergencyCategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmergencyProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategoryChip(
                context,
                value: 'all',
                label: 'All',
                icon: Icons.apps,
                isSelected: provider.selectedCategory == 'all',
              ),
              _buildCategoryChip(
                context,
                value: 'police',
                label: 'Police',
                icon: Icons.local_police,
                isSelected: provider.selectedCategory == 'police',
              ),
              _buildCategoryChip(
                context,
                value: 'fire',
                label: 'Fire',
                icon: Icons.local_fire_department,
                isSelected: provider.selectedCategory == 'fire',
              ),
              _buildCategoryChip(
                context,
                value: 'ambulance',
                label: 'Ambulance',
                icon: Icons.local_hospital,
                isSelected: provider.selectedCategory == 'ambulance',
              ),
              _buildCategoryChip(
                context,
                value: 'sar',
                label: 'SAR',
                icon: Icons.sailing,
                isSelected: provider.selectedCategory == 'sar',
              ),
              _buildCategoryChip(
                context,
                value: 'disaster',
                label: 'Disaster',
                icon: Icons.warning,
                isSelected: provider.selectedCategory == 'disaster',
              ),
              _buildCategoryChip(
                context,
                value: 'utility',
                label: 'Utility',
                icon: Icons.bolt,
                isSelected: provider.selectedCategory == 'utility',
              ),
              _buildCategoryChip(
                context,
                value: 'hotline',
                label: 'Hotline',
                icon: Icons.phone,
                isSelected: provider.selectedCategory == 'hotline',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (_) {
          context.read<EmergencyProvider>().loadServicesByCategory(value);
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.red[100],
        checkmarkColor: Colors.red[700],
        labelStyle: TextStyle(
          color: isSelected ? Colors.red[700] : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }
}
