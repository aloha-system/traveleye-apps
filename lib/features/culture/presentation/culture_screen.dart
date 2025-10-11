import 'package:flutter/material.dart';

class CultureScreen extends StatelessWidget {
  const CultureScreen({super.key});

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
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
      ),
      body: Center(child: Text('ini adalah culture screen')),
    );
  }
}
