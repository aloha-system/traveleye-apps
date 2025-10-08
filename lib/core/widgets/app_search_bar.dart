import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onFilterTap;
  final VoidCallback? onTap;

  const AppSearchBar({
    super.key,
    this.hintText = 'Cari destinasi wisata...',
    this.onFilterTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hintText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
              ),
            ),
            InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.filter_list,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


