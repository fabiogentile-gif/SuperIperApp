import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 72,
        title: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Le tue carte',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text(
                'Tutte le tue carte fedeltà in un posto solo',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
      body: const Center(child: Text('Nessuna carta')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
