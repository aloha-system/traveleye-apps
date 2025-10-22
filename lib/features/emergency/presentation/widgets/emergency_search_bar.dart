import 'package:boole_apps/features/emergency/presentation/provider/emergency_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmergencySearchBar extends StatefulWidget {
  const EmergencySearchBar({Key? key}) : super(key: key);

  @override
  State<EmergencySearchBar> createState() => _EmergencySearchBarState();
}

class _EmergencySearchBarState extends State<EmergencySearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Debounce search untuk performa lebih baik
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == value) {
        context.read<EmergencyProvider>().searchServices(value);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<EmergencyProvider>().loadAllServices();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search emergency services...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}