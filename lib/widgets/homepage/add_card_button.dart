import 'package:flutter/material.dart';
import 'package:superiper_app/widgets/homepage/add_card_sheet.dart';

class AddCardButton extends StatelessWidget {
  final ValueChanged<NewCardData> onSave;

  const AddCardButton({super.key, required this.onSave});

  void _handleAdd(BuildContext context) async {
    final result = await showAddCardSheet(context);
    if (result != null && context.mounted) {
      onSave(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 50,
          child: FilledButton.icon(
            onPressed: () => _handleAdd(context),
            icon: const Icon(Icons.add),
            label: const Text('Aggiungi carta'),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
