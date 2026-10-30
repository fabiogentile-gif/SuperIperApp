import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superiper_app/widgets/homepage/card_detail_sheet.dart';

void main() {
  const code = '0470230083621';

  test('una carta EAN-13 viene disegnata come EAN-13', () {
    expect(barcodeForFormat('ean13', code).name, 'EAN 13');
  });

  test('le barre di EAN-13 con zero e UPC-A sono identiche', () {
    final ean13 = Barcode.ean13().toSvg(code, drawText: false);
    final upcA = Barcode.upcA().toSvg(code.substring(1), drawText: false);

    expect(ean13, upcA);
  });

  test('formati sconosciuti e codici non validi usano il Code 128', () {
    expect(barcodeForFormat('CODE_128', code).name, 'CODE 128');
    expect(barcodeForFormat('ean13', '1234').name, 'CODE 128');
  });

  test('i codici QR restano QR', () {
    expect(barcodeForFormat('qrCode', 'abc').name, 'QR-Code');
  });

  test('il codice è diviso come sulla carta', () {
    expect(groupCode(code, 'ean13'), '0 470230 083621');
    expect(groupCode('12345678', 'ean8'), '1234 5678');
    expect(groupCode('123456789012', 'upcA'), '1 23456 78901 2');
    expect(groupCode('123456789', 'CODE_128'), '1234 5678 9');
  });
}
