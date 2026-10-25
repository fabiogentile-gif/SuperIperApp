import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../domain/card.dart' as model;

class CardDetailSheet extends StatelessWidget {
  final model.Card card;

  const CardDetailSheet({super.key, required this.card});

  Barcode _getBarcode() {
    switch (card.barcodeFormat.toLowerCase()) {
      case 'ean_13':
      case 'ean13':
        return Barcode.ean13();
      case 'ean_8':
      case 'ean8':
        return Barcode.ean8();
      case 'upc_a':
      case 'upca':
        return Barcode.upcA();
      case 'upc_e':
      case 'upce':
        return Barcode.upcE();
      case 'code_39':
      case 'code39':
        return Barcode.code39();
      case 'itf':
        return Barcode.itf();
      case 'codabar':
        return Barcode.codabar();
      case 'code_128':
      case 'code128':
      default:
        return Barcode.code128();
    }
  }

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xFFFFFAF3);
    const terracotta = Color(0xFFB95129);
    const peach = Color(0xFFF8D9C8);
    const green = Color(0xFFD9F0E4);
    const darkGreen = Color(0xFF285C49);
    const muted = Color(0xFF796C60);

    return Container(
      decoration: const BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Dettagli carta',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF29231F),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Chiudi',
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF4EEE5),
                    ),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Anteprima grafica della tessera.
              SizedBox(
                height: 140,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.eco_outlined,
                              color: darkGreen,
                              size: 29,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                card.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.star_border,
                              color: darkGreen,
                              size: 23,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'La spesa, più buona.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                            Text(
                              'Spesa',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Codice da mostrare alla cassa.
              Container(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                decoration: BoxDecoration(
                  color: cream,
                  border: Border.all(color: const Color(0xFFDDCDBB)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Mostra il codice alla cassa',
                      style: TextStyle(fontSize: 14, color: muted),
                    ),
                    const SizedBox(height: 10),
                    BarcodeWidget(
                      barcode: _getBarcode(),
                      data: card.barcode,
                      width: 300,
                      height: 75,
                      drawText: false,
                      errorBuilder: (context, error) {
                        return const SizedBox(
                          height: 75,
                          child: Center(
                            child: Text(
                              'Formato del codice non valido',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    SelectableText(
                      card.barcode,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Color(0xFF29231F),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Codice dimostrativo · non utilizzabile',
                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Informazioni della carta.
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Intestatario',
                          style: TextStyle(fontSize: 13, color: muted),
                        ),
                        SizedBox(height: 6),
                        Text('Non specificato', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo di carta',
                          style: TextStyle(fontSize: 13, color: muted),
                        ),
                        SizedBox(height: 6),
                        Text('Carta fedeltà', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Pulsante di modifica.
              SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'La modifica della carta sarà disponibile '
                          'in una prossima implementazione.',
                        ),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: peach,
                    foregroundColor: terracotta,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text(
                    'Modifica carta',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
