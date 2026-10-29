class Card {
  final int? id;
  final String name;
  final String barcode;
  final String barcodeFormat;
  final String category;
  final DateTime createdAt;

  const Card({
    this.id,
    required this.name,
    required this.barcode,
    required this.barcodeFormat,
    this.category = 'Supermercato',
    required this.createdAt,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'barcode_format': barcodeFormat,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Card.fromMap(Map<String, Object?> map) {
    return Card(
      id: map['id'] as int?,
      name: map['name'] as String,
      barcode: map['barcode'] as String,
      barcodeFormat: map['barcode_format'] as String,
      category: map['category'] as String? ?? 'Supermercato',
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
