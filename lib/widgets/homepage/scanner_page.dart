import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController _controller = MobileScannerController();

  String? _barcode;
  String? _barcodeFormat;

  void _onDetect(BarcodeCapture capture) {
    if (_barcode != null) return;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;

      if (value != null && value.trim().isNotEmpty) {
        setState(() {
          _barcode = value.trim();
          _barcodeFormat = barcode.format.name;
        });

        _controller.stop();
        return;
      }
    }
  }

  void _useScannedCode() {
    if (_barcode == null || _barcodeFormat == null) return;

    Navigator.of(context)
        .pop({'barcode': _barcode!, 'format': _barcodeFormat!});
  }

  void _retryScan() {
    setState(() {
      _barcode = null;
      _barcodeFormat = null;
    });

    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scansiona carta'),
        actions: [
          if (_barcode == null)
            IconButton(
              tooltip: 'Attiva o disattiva il flash',
              onPressed: () => _controller.toggleTorch(),
              icon: const Icon(Icons.flash_on),
            ),
          if (_barcode == null)
            IconButton(
              tooltip: 'Cambia fotocamera',
              onPressed: () => _controller.switchCamera(),
              icon: const Icon(Icons.cameraswitch),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(controller: _controller, onDetect: _onDetect),
                if (_barcode == null)
                  IgnorePointer(
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.greenAccent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                if (_barcode == null)
                  const Positioned(
                    left: 20,
                    right: 20,
                    bottom: 24,
                    child: Text(
                      'Inquadra il codice a barre della carta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_barcode != null)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Codice rilevato',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  SelectableText(_barcode!),
                  const SizedBox(height: 6),
                  Text('Formato: $_barcodeFormat'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _useScannedCode,
                    icon: const Icon(Icons.check),
                    label: const Text('Usa questo codice'),
                  ),
                  TextButton(
                    onPressed: _retryScan,
                    child: const Text('Scansiona di nuovo'),
                  ),
                ],
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Posiziona il codice dentro il riquadro.',
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
