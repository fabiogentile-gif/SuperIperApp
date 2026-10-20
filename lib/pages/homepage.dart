import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Le mie carte'),backgroundColor: Theme.of(context).scaffoldBackgroundColor,),
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