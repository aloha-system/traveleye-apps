import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/detail_provider.dart';

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<DetailNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Destination')),
      body: c.loading
          ? const Center(child: CircularProgressIndicator())
          : c.error != null
              ? Center(child: Text('Error: ${c.error}'))
              : c.data == null
                  ? const Center(child: Text('No Data'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              c.data!.imageUrls.first,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(c.data!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          Text('${c.data!.city}, ${c.data!.province}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amber[700], size: 20),
                              const SizedBox(width: 4),
                              Text('${c.data!.rating}'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(c.data!.description,
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 24),
                          Text('Facility:',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: c.data!.facilities
                                .map((f) => Chip(label: Text(f)))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
