import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Quanto l'utente deve restare sul codice prima della conferma automatica.
const _holdDuration = Duration(milliseconds: 2500);

/// Senza letture per questo tempo il codice è considerato perso.
const _lostTimeout = Duration(milliseconds: 800);

class ScannedCode {
  const ScannedCode(this.value, this.format);

  final String value;
  final String format;
}

/// Restituisce il codice letto, o null se la lettura è vuota.
ScannedCode? normalizeScannedCode(String? rawValue, BarcodeFormat format) {
  final value = rawValue?.trim() ?? '';
  if (value.isEmpty) return null;

  // Un EAN-13 che inizia con 0 viene riconosciuto come UPC-A, a 12 cifre:
  // lo zero stampato sulla carta va rimesso. Le barre restano identiche.
  if (format == BarcodeFormat.upcA && value.length == 12) {
    return ScannedCode('0$value', BarcodeFormat.ean13.name);
  }

  return ScannedCode(value, format.name);
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  late final AnimationController _hold;

  Timer? _lostTimer;
  ScannedCode? _candidate;
  String? _mismatch;
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    _hold = AnimationController(vsync: this, duration: _holdDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _confirm();
      });
  }

  void _onDetect(BarcodeCapture capture) {
    if (_confirmed) return;

    final codes = capture.barcodes
        .map((b) => normalizeScannedCode(b.rawValue, b.format))
        .whereType<ScannedCode>()
        .toList();
    if (codes.isEmpty) return;

    _lostTimer?.cancel();
    _lostTimer = Timer(_lostTimeout, _reset);

    final current = _candidate;
    if (current != null && codes.any((c) => c.value == current.value)) {
      _mismatch = null;
      return;
    }

    // Una singola lettura diversa può essere un errore: il codice cambia solo
    // se la stessa lettura si ripete.
    final next = codes.first;
    if (current != null && _mismatch != next.value) {
      _mismatch = next.value;
      return;
    }

    _mismatch = null;
    setState(() => _candidate = next);
    _hold.forward(from: 0);
  }

  void _reset() {
    _mismatch = null;
    _hold.reset();
    setState(() => _candidate = null);
  }

  void _confirm() {
    final code = _candidate;
    if (code == null || _confirmed) return;

    _confirmed = true;
    _lostTimer?.cancel();

    Navigator.of(context).pop({'barcode': code.value, 'format': code.format});
  }

  @override
  void dispose() {
    _lostTimer?.cancel();
    _hold.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPanel(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final code = _candidate;

    return Container(
      color: colors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: code == null
              ? Text(
                  'Inquadra tutto il codice a barre dentro il riquadro.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Codice rilevato',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      code.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedBuilder(
                      animation: _hold,
                      builder: (context, _) =>
                          LinearProgressIndicator(value: _hold.value),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Resta fermo sul codice per confermarlo.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scansiona carta'),
        actions: [
          IconButton(
            tooltip: 'Attiva o disattiva il flash',
            onPressed: () => _controller.toggleTorch(),
            icon: const Icon(Icons.flash_on),
          ),
          IconButton(
            tooltip: 'Cambia fotocamera',
            onPressed: () => _controller.switchCamera(),
            icon: const Icon(Icons.cameraswitch),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Vengono accettati solo i codici interi dentro il riquadro.
          final scanWindow = Rect.fromCenter(
            center: constraints.biggest.center(Offset.zero),
            width: min(300, constraints.maxWidth - 48),
            height: 150,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                controller: _controller,
                scanWindow: scanWindow,
                onDetect: _onDetect,
              ),
              Positioned.fromRect(
                rect: scanWindow,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _candidate == null
                            ? Colors.white
                            : Colors.greenAccent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildPanel(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
