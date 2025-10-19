import 'package:boole_apps/features/culture/presentation/provider/culture_provider.dart';
import 'package:boole_apps/features/culture/presentation/provider/culture_state.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                    children: [
                      Text(
                        provider.cultureDetail!.province,
                        style: Theme.of(context).textTheme.bodyLarge,
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
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ),
      ),

      // Leading Appbar
      // leadingWidth: 80.0,
      // leading: Container(
      //   margin: const EdgeInsets.only(left: 24),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(56),
      //     child: BackdropFilter(
      //       filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      //       child: Container(
      //         height: 56,
      //         width: 56,
      //         alignment: Alignment.center,
      //         decoration: BoxDecoration(
      //           shape: BoxShape.circle,
      //           color: Theme.of(context).colorScheme.surface,
      //         ),
      //         child: Icon(Icons.arrow_back_ios_new),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
