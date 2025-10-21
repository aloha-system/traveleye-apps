import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CultureDetailAppBar extends StatelessWidget {
  final List<String>? imageUrl;

  const CultureDetailAppBar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final List<String> images = (imageUrl == null || imageUrl!.isEmpty)
        ? ['image fallback']
        : imageUrl!;

    return SliverAppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      expandedHeight: 275.0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0.0,
      pinned: true,
      stretch: true,

      // Body Appbar
      flexibleSpace: FlexibleSpaceBar(
        background: CarouselSlider(
          items: images.map((url) {
            return Image.network(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 60)),
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            height: double.infinity,
          ),
        ),
        stretchModes: [StretchMode.blurBackground, StretchMode.zoomBackground],
      ),

      // Bottom Appbar
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          height: 32.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
          ),
          child: Container(
            width: 40.0,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withAlpha((0.6 * 255).round()),
            child: Icon(Icons.arrow_back),
          ),
        ),
      ),
    );
  }
}
