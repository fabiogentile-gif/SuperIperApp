import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:superiper_app/widgets/homepage/scanner_page.dart';

void main() {
  test('UPC-A a 12 cifre riprende lo zero iniziale come EAN-13', () {
    final code = normalizeScannedCode('123456789012', BarcodeFormat.upcA);

    expect(code?.value, '0123456789012');
    expect(code?.format, 'ean13');
  });

  test('gli altri formati mantengono valore e zeri iniziali', () {
    final code = normalizeScannedCode(' 0012345 ', BarcodeFormat.code128);

    expect(code?.value, '0012345');
    expect(code?.format, 'code128');
  });

  test('una lettura vuota viene ignorata', () {
    expect(normalizeScannedCode(null, BarcodeFormat.ean13), isNull);
    expect(normalizeScannedCode('   ', BarcodeFormat.ean13), isNull);
  });
}
