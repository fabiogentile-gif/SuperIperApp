import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:superiper_app/widgets/segments.dart';
=======
import 'package:superiper_app/widgets/homepage/scanner_page.dart';
import 'package:superiper_app/models/loyalty_card.dart';
import 'package:superiper_app/providers/card_provider.dart';
>>>>>>> Testing
import 'package:superiper_app/widgets/settings/utils/default_holder_controller.dart';

class NewCardData {
  const NewCardData({
    required this.storeName,
    required this.number,
    required this.category,
    required this.holder,
    this.barcodeFormat = 'CODE_128',
  });

  final String storeName;
  final String number;
  final String category;
  final String holder;
  final String barcodeFormat;
}

/// Apre il popup dal basso. Restituisce i dati della carta, o null se chiuso.
Future<NewCardData?> showAddCardSheet(BuildContext context) {
  return showModalBottomSheet<NewCardData>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const AddCardSheet(),
  );
}

Future<void> showEditCardSheet(
  BuildContext context,
  LoyaltyCard card, {
  required CardProvider provider,
}) async {
  final result = await showModalBottomSheet<NewCardData>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddCardSheet(
      initialCard: card,
      title: 'Modifica carta',
      submitLabel: 'Salva modifiche',
    ),
  );

  if (result == null) return;

  provider.updateCard(
    card.code,
    name: result.storeName,
    code: result.number,
    category: result.category,
    holder: result.holder,
    barcodeFormat: result.barcodeFormat,
  );
}

enum _InputMode { scan, manual }

class AddCardSheet extends StatefulWidget {
  const AddCardSheet({
    super.key,
    this.initialCard,
    this.title = 'Aggiungi carta',
    this.submitLabel = 'Crea carta',
  });

  final LoyaltyCard? initialCard;
  final String title;
  final String submitLabel;

  @override
  State<AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet> {
  static const _categories = [
    'Spesa',
    'Farmacia',
    'Abbigliamento',
    'Casa',
    'Altro',
  ];

  final _store = TextEditingController();
  final _number = TextEditingController();
  final _holder = TextEditingController(text: defaultHolderName.value);
  _InputMode _mode = _InputMode.manual;
  String _category = _categories.first;

  String _barcodeFormat = 'CODE_128';
  String? _scannedValue;

  Future<void> _scan() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(builder: (_) => const ScannerPage()),
    );

    if (result == null || !mounted) return;

    setState(() {
      _number.text = result['barcode']!;
      _scannedValue = result['barcode'];
      _barcodeFormat = result['format'] ?? 'CODE_128';
      _mode = _InputMode.manual;
    });
  }

  @override
  void initState() {
    super.initState();

    final card = widget.initialCard;
    if (card != null) {
      _store.text = card.name;
      _number.text = card.code;
      _holder.text = card.holder;
      _barcodeFormat = card.barcodeFormat;
      _scannedValue = card.code;
      if (card.category.isNotEmpty) {
        _category = card.category;
      }
    }
  }

  bool get _canSubmit =>
      _store.text.trim().isNotEmpty && _number.text.trim().isNotEmpty;

  @override
  void dispose() {
    _store.dispose();
    _number.dispose();
    _holder.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop(
      NewCardData(
        storeName: _store.text.trim(),
        number: _number.text.trim(),
        category: _category,
        holder: _holder.text.trim(),
        barcodeFormat: _barcodeFormat,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fieldWidth = MediaQuery.sizeOf(context).width - 48;
    final hintStyle = TextStyle(fontSize: 14, color: colors.onSurfaceVariant);
    final valueStyle = TextStyle(fontSize: 14, color: colors.onSurface);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 34),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.outline,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              SizedBox(
                height: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 20, color: colors.onSurface),
                    ),
                    Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).pop(),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Text(
                'Le tue fedeltà, tutte qui.',
                style: TextStyle(fontSize: 24, color: colors.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                'Scansiona il codice o inserisci i dati della tua carta.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),

              // Metodo di inserimento
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Segment(
                        label: 'Scansiona',
                        icon: Icons.document_scanner_outlined,
                        iconSize: 17,
                        selected: _mode == _InputMode.scan,
                        onTap: _scan,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Segment(
                        label: 'A mano',
                        icon: Icons.edit_outlined,
                        iconSize: 16,
                        selected: _mode == _InputMode.manual,
                        onTap: () => setState(() => _mode = _InputMode.manual),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Dati della carta
              _Field(
                label: 'Nome del negozio',
                child: _FieldBox(
                  icon: Icons.storefront_outlined,
                  child: TextField(
                    controller: _store,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: colors.primary,
                    style: valueStyle,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Natura',
                      hintStyle: hintStyle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _Field(
                label: 'Numero della carta',
                helper: 'Codice di esempio, non utilizzabile in negozio.',
                child: _FieldBox(
                  icon: Icons.view_week_outlined,
                  child: TextField(
                    controller: _number,
                    keyboardType: TextInputType.number,
                    cursorColor: colors.primary,
                    style: valueStyle,
                    decoration: InputDecoration.collapsed(
                      hintText: '9820 4512 7308 64',
                      hintStyle: hintStyle,
                    ),
                    onChanged: (v) {
                      if (v.trim() != _scannedValue)
                        _barcodeFormat = 'CODE_128';
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _Field(
                label: 'Intestatario',
                child: _FieldBox(
                  icon: Icons.person_outline,
                  child: TextField(
                    controller: _holder,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: colors.primary,
                    style: valueStyle,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Nome e cognome',
                      hintStyle: hintStyle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _Field(
                label: 'Categoria',
                child: PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  color: colors.surface,
                  surfaceTintColor: Colors.transparent,
                  elevation: 2,
                  constraints: BoxConstraints.tightFor(width: fieldWidth),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: colors.outline),
                  ),
                  onSelected: (v) => setState(() => _category = v),
                  itemBuilder: (_) => [
                    for (final c in _categories)
                      PopupMenuItem(
                        value: c,
                        child: Text(c, style: valueStyle),
                      ),
                  ],
                  child: _FieldBox(
                    icon: Icons.keyboard_arrow_down_rounded,
                    child: Text(_category, style: valueStyle),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Nota
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 15,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Puoi modificare questi dettagli quando vuoi.',
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Azione principale
              ListenableBuilder(
                listenable: Listenable.merge([_store, _number]),
                builder: (context, _) => Opacity(
                  opacity: _canSubmit ? 1 : 0.5,
                  child: Material(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: _canSubmit ? _submit : null,
                      child: SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 21, color: colors.onPrimary),
                            const SizedBox(width: 10),
                            Text(
                              widget.submitLabel,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: colors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child, this.helper});

  final String label;
  final Widget child;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        child,
        if (helper != null) ...[
          const SizedBox(height: 8),
          Text(
            helper!,
            style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _FieldBox extends StatelessWidget {
  const _FieldBox({required this.child, required this.icon});

  final Widget child;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(child: child),
          const SizedBox(width: 8),
          Icon(icon, size: 18, color: colors.onSurface),
        ],
      ),
    );
  }
}
