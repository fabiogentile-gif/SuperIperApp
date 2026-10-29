import 'package:flutter/material.dart';

import '../data/card_repository.dart';
import '../domain/card.dart' as model;
import 'scanner_page.dart';

class AddCardSheet extends StatefulWidget {
  const AddCardSheet({super.key});

  @override
  State<AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet> {
  final _repository = CardRepository();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();

  static const List<String> _categories = [
    'Supermercato',
    'Abbigliamento',
    'Tecnologia',
    'Casa',
    'Sport',
    'Salute e bellezza',
    'Altro',
  ];

  bool _scanMode = true;
  bool _saving = false;
  String _barcodeFormat = 'CODE_128';
  String? _selectedCategory = 'Supermercato';

  Future<void> _startScan() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(builder: (_) => const ScannerPage()),
    );

    if (!mounted || result == null) return;

    setState(() {
      _barcodeController.text = result['barcode'] ?? '';
      _barcodeFormat = result['format'] ?? 'CODE_128';
      _scanMode = false;
    });
  }

  Future<void> _createCard() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      await _repository.save(
        model.Card(
          name: _nameController.text.trim(),
          barcode: _barcodeController.text.trim(),
          barcodeFormat: _barcodeFormat,
          category: _selectedCategory ?? 'Supermercato',
          createdAt: DateTime.now(),
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;

      setState(() => _saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Impossibile salvare la carta. '
            'Potrebbe essere già presente.',
          ),
        ),
      );
    }
  }

  Future<void> _handlePrimaryAction() async {
    if (_saving) return;

    if (_scanMode) {
      await _startScan();
    } else {
      await _createCard();
    }
  }

  IconData _categoryIcon(String category) {
    return switch (category) {
      'Supermercato' => Icons.shopping_cart_outlined,
      'Abbigliamento' => Icons.checkroom_outlined,
      'Tecnologia' => Icons.devices_outlined,
      'Casa' => Icons.chair_outlined,
      'Sport' => Icons.sports_soccer_outlined,
      'Salute e bellezza' => Icons.spa_outlined,
      _ => Icons.category_outlined,
    };
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required ColorScheme colors,
  }) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: Icon(icon, color: colors.onSurfaceVariant),
      filled: true,
      fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.35),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.error, width: 1.8),
      ),
    );
  }

  Widget _fieldLabel(String label, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildManualForm(ThemeData theme, ColorScheme colors) {
    return Column(
      key: const ValueKey('manual-form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _fieldLabel('Nome del negozio', theme),
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: _inputDecoration(
            hint: 'Es. Natura',
            icon: Icons.store_outlined,
            colors: colors,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Inserisci il nome del negozio';
            }
            return null;
          },
        ),

        const SizedBox(height: 18),

        _fieldLabel('Numero della carta', theme),
        TextFormField(
          controller: _barcodeController,
          decoration: _inputDecoration(
            hint: 'Inserisci il codice a barre',
            icon: Icons.numbers_rounded,
            colors: colors,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Inserisci il numero della carta';
            }
            return null;
          },
          onChanged: (_) {
            _barcodeFormat = 'CODE_128';
          },
        ),

        const SizedBox(height: 18),

        _fieldLabel('Categoria', theme),
        DropdownButtonFormField<String>(
          key: const ValueKey('category-dropdown'),
          initialValue: _selectedCategory,
          isExpanded: true,
          alignment: AlignmentDirectional.centerStart,
          borderRadius: BorderRadius.circular(16),
          dropdownColor: colors.surfaceContainer,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colors.onSurfaceVariant,
            size: 24,
          ),
          decoration:
              _inputDecoration(
                hint: 'Seleziona una categoria',
                icon: Icons.category_outlined,
                colors: colors,
              ).copyWith(
                // Nessuna icona di categoria nel campo chiuso.
                suffixIcon: null,
                prefixIcon: null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 17,
                ),
              ),
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Row(
                children: [
                  Icon(
                    _categoryIcon(category),
                    size: 20,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  if (_selectedCategory == category)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.check_rounded,
                        size: 19,
                        color: colors.primary,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
          selectedItemBuilder: (context) {
            return _categories.map((category) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
              );
            }).toList();
          },
          onChanged: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Seleziona una categoria';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildScanPanel(ThemeData theme, ColorScheme colors) {
    return Column(
      key: const ValueKey('scan-panel'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            Icons.document_scanner_outlined,
            size: 42,
            color: colors.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Pronto a scansionare?',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Inquadra il codice a barre della tessera. '
          'Potrai inserire il nome e la categoria prima di salvarla.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Aggiungi carta',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Chiudi',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                'Le tue fedeltà, tutte qui.',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Scansiona il codice o inserisci i dati della tua carta.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment<bool>(value: true, label: Text('Scansiona')),
                  ButtonSegment<bool>(
                    value: false,
                    icon: Icon(Icons.edit_outlined),
                    label: Text('A mano'),
                  ),
                ],
                selected: {_scanMode},
                onSelectionChanged: (selection) {
                  setState(() {
                    _scanMode = selection.first;
                  });
                },
              ),

              const SizedBox(height: 24),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _scanMode
                    ? _buildScanPanel(theme, colors)
                    : _buildManualForm(theme, colors),
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _saving ? null : _handlePrimaryAction,
                icon: Icon(
                  _scanMode ? Icons.document_scanner_outlined : Icons.add,
                ),
                label: Text(
                  _saving
                      ? 'Salvataggio...'
                      : _scanMode
                      ? 'Avvia scansione'
                      : 'Crea carta',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
