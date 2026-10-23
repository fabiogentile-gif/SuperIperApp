import 'package:flutter/material.dart';
import 'package:superiper_app/widgets/settings/utils/default_holder_controller.dart';

class DefaultHolderSelector extends StatelessWidget {
  const DefaultHolderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ValueListenableBuilder<String>(
      valueListenable: defaultHolderName,
      builder: (context, name, _) => InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _edit(context, name),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 96,
                child: Text(
                  name.isEmpty ? 'Imposta' : name,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right,
                  size: 20, color: colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, String current) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _HolderSheet(
        initialValue: current,
        onSave: (value) => defaultHolderName.value = value.trim(),
      ),
    );
  }
}

class _HolderSheet extends StatefulWidget {
  const _HolderSheet({required this.initialValue, required this.onSave});

  final String initialValue;
  final ValueChanged<String> onSave;

  @override
  State<_HolderSheet> createState() => _HolderSheetState();
}

class _HolderSheetState extends State<_HolderSheet> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(_controller.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Alza il contenuto sopra la tastiera
      padding: EdgeInsets.fromLTRB(
        20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Intestatario predefinito',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Verrà proposto per le carte che salverai da ora in poi. '
            'Le carte già salvate non cambiano.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: const InputDecoration(
              labelText: 'Nome e cognome',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _save, child: const Text('Salva')),
          ),
        ],
      ),
    );
  }
}