
import 'package:flutter/material.dart';

class CardSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const CardSearchBar({
    super.key,
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SearchBar(
        controller: controller,
        hintText: 'Cerca una carta',
        leading: const Icon(Icons.search),
        elevation: const WidgetStatePropertyAll(0),
        onChanged: onChanged,
        trailing: [
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}
