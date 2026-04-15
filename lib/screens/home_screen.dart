import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/practice_options_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practiceOptions = ref.watch(practiceOptionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('CS Practice')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Welcome to CS Practice',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Build core computer science skills with short, focused practice sets.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Text(
            'Practice Types',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...practiceOptions.map(
            (option) => Card(
              child: ListTile(
                leading: const Icon(Icons.memory),
                title: Text(option.title),
                subtitle: Text(option.description),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
