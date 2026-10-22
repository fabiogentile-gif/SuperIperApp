import 'dart:math' show min;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class LoyaltyCard {
  final String name;
  final String code;
  final String tagline;
  final String category;
  final String holder;
  final String type;
  final IconData icon;
  final Color color;
  final Color onColor;
  final bool isFavorite;

  const LoyaltyCard({
    required this.name,
    required this.code,
    this.tagline = '',
    this.category = '',
    this.holder = '',
    this.type = 'Carta fedeltà',
    this.icon = Icons.eco_outlined,
    this.color = const Color(0xFFDBEFE3),
    this.onColor = const Color(0xFF285943),
    this.isFavorite = false,
  });
}

abstract final class _C {
  static const sheet = Color(0xFFFFFBF5);
  static const line = Color(0xFFD8CCBB);
  static const chip = Color(0xFFF6F1E9);
  static const text = Color(0xFF1F1B18);
  static const muted = Color(0xFF6A5F55);
  static const bars = Color(0xFF171B26);
  static const editBg = Color(0xFFF6D9C9);
  static const editFg = Color(0xFFB4532A);
}

Future<void> showCardDetailsSheet(
  BuildContext context,
  LoyaltyCard card, {
  VoidCallback? onEdit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true, // copre anche la bottom bar della shell
    isScrollControlled: true,
    backgroundColor: _C.sheet,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (sheetContext) => _CardDetailsSheet(
      card: card,
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
    required this.onClose,
    this.onEdit,
  });

  final LoyaltyCard card;
  final VoidCallback onClose;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
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
                color: _C.line,
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
                  const Text(
                    'Dettagli carta',
                    style: TextStyle(fontSize: 20, color: _C.text),
                  ),
                  Material(
                    color: _C.chip,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onClose,
                      child: const SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(Icons.close, size: 18, color: _C.text),
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
                      Icon(
                        card.isFavorite ? Icons.star : Icons.star_border,
                        size: 20,
                        color: card.onColor,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(card.tagline,
                          style: TextStyle(fontSize: 12, color: card.onColor)),
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
                border: Border.all(color: _C.line),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Mostra il codice alla cassa',
                    style: TextStyle(fontSize: 13, color: _C.muted),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 268,
                    height: 68,
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: card.code.replaceAll(' ', ''),
                      drawText: false,
                      color: _C.bars,
                      backgroundColor: Colors.white, // necessario per lo scanner
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _group(card.code),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: _C.text,
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
                  Expanded(child: _Info(label: 'Intestatario', value: card.holder)),
                  const SizedBox(width: 28),
                  Expanded(child: _Info(label: 'Tipo di carta', value: card.type)),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Modifica
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Material(
                color: _C.editBg,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onEdit,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_outlined, size: 18, color: _C.editFg),
                      SizedBox(width: 8),
                      Text(
                        'Modifica carta',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _C.editFg,
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
        Text(label, style: const TextStyle(fontSize: 12, color: _C.muted)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _C.text,
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