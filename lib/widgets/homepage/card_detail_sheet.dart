import 'dart:math' show min;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:superiper_app/models/loyalty_card.dart';
import 'package:superiper_app/providers/card_provider.dart';

Future<void> showCardDetailsSheet(
  BuildContext context,
  LoyaltyCard card, {
  required CardProvider provider,
  VoidCallback? onEdit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true, // copre anche la bottom bar della shell
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (sheetContext) => _CardDetailsSheet(
      card: card,
      provider: provider,
      onClose: () => Navigator.of(sheetContext).pop(),
      onEdit: onEdit == null
          ? null
          : () {
              Navigator.of(sheetContext).pop();
              onEdit();
            },
    ),
  );
}

class _CardDetailsSheet extends StatelessWidget {
  const _CardDetailsSheet({
    required this.card,
    required this.provider,
    required this.onClose,
    this.onEdit,
  });

  final LoyaltyCard card;
  final CardProvider provider;
  final VoidCallback onClose;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 34),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Maniglia
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outline,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 18),

            // Intestazione
            SizedBox(
              height: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dettagli carta',
                    style: TextStyle(
                      fontSize: 20,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Material(
                    color: colors.surfaceContainerHighest,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onClose,
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Carta
            Container(
              height: 126,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: card.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(card.icon, size: 30, color: card.onColor),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                card.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 29,
                                  fontWeight: FontWeight.w700,
                                  color: card.onColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListenableBuilder(
                        listenable: provider,
                        builder: (_, __) => InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => provider.toggleFavorite(card.code),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              provider.isFavorite(card.code)
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 20,
                              color: card.onColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        card.category,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: card.onColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Codice da mostrare
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                border: Border.all(color: colors.outline),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text(
                    'Mostra il codice alla cassa',
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 268,
                    height: 68,
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: card.code.replaceAll(' ', ''),
                      drawText: false,
                      color: Colors.black,
                      backgroundColor:
                          Colors.white, // necessario per lo scanner
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _group(card.code),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Informazioni
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _Info(label: 'Intestatario', value: card.holder),
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    child: _Info(label: 'Tipo di carta', value: card.type),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Modifica
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Material(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onEdit,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: colors.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Modifica carta',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

String _group(String code) {
  final c = code.replaceAll(' ', '');
  return [
    for (var i = 0; i < c.length; i += 4) c.substring(i, min(i + 4, c.length)),
  ].join(' ');
}
