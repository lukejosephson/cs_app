import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/practice_options_provider.dart';
import '../widgets/home/practice_option_tile.dart';
import '../widgets/home/welcome_card.dart';
import 'binary_practice_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practiceOptions = ref.watch(practiceOptionsProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('CS Practice')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const WelcomeCard(),
          const SizedBox(height: 24),
          Text(
            'Practice Types',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.88),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...practiceOptions.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PracticeOptionTile(
                option: option,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const BinaryPracticeScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
