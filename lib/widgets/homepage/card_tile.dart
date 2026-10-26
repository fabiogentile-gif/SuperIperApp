import 'package:flutter/material.dart';
import 'package:superiper_app/widgets/homepage/card_detail_sheet.dart';

class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    required this.name,
    required this.code,
    this.holder = '',
    this.category = '',
    this.icon = Icons.credit_card,
    this.accentColor,
    this.onTap,
  });

  final String name;
  final String code;
  final String holder;
  final String category;
  final IconData icon;
  final Color? accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: colors.surfaceContainerHighest,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap:
            onTap ??
            () => showCardDetailsSheet(
              context,
              LoyaltyCard(name: name, code: code,holder: holder,category: category),
            ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: accentColor ?? colors.primary),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
