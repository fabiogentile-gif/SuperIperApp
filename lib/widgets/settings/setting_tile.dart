import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.rowChild,
    this.columnChild,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? rowChild; // a destra di titolo/sottotitolo
  final Widget? columnChild; // sotto titolo/sottotitolo

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 24,
                child: Icon(icon, size: 24, color: cs.onSurfaceVariant),
              ),
              const SizedBox(width: 16),
              Expanded(child: header),
              if (rowChild != null) ...[const SizedBox(width: 12), rowChild!],
            ],
          ),
          if (columnChild != null) ...[
            const SizedBox(height: 14),
            columnChild!,
          ],
        ],
      ),
    );
  }
}
