import 'package:flutter/material.dart';
import 'package:superiper_app/features/cards/data/card_repository.dart';
import 'package:superiper_app/features/cards/domain/card.dart' as model;
import 'package:superiper_app/features/cards/presentation/card_detail_sheet.dart';
import 'package:superiper_app/features/cards/presentation/add_card_sheet.dart';
import 'package:superiper_app/widgets/card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardRepository _repository = CardRepository();

  List<model.Card> _cards = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    try {
      final cards = await _repository.getAll();

      if (!mounted) return;

      setState(() {
        _cards = cards;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Impossibile caricare le carte salvate.';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCard(model.Card card) async {
    if (card.id == null) return;

    try {
      await _repository.delete(card.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Carta eliminata')));

      await _loadCards();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Errore durante l’eliminazione della carta'),
        ),
      );
    }
  }

  Future<void> _addCard() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => const AddCardSheet(),
    );

    if (saved == true && mounted) {
      await _loadCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Le mie carte')),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
          _buildAddCardButton(),
        ],
      ),
    );
  }

  Widget _buildAddCardButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton.icon(
          onPressed: _addCard,
          icon: const Icon(Icons.add),
          label: const Text(
            'Aggiungi carta',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                _loadCards();
              },
              child: const Text('Riprova'),
            ),
          ],
        ),
      );
    }

    if (_cards.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.credit_card_outlined, size: 64),
              SizedBox(height: 16),
              Text(
                'Non hai ancora carte salvate',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Premi “Aggiungi carta” per iniziare.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCards,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        showDragHandle: true,
                        builder: (context) {
                          return CardDetailSheet(card: card);
                        },
                      );
                    },
                    child: MiaCard(
                      titolo: card.name,
                      descrizione:
                          'Codice: ${card.barcode}\n'
                          'Formato: ${card.barcodeFormat}',
                      icona: Icons.card_membership,
                      colore: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Elimina carta',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(card),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(model.Card card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminare la carta?'),
        content: Text('Vuoi eliminare "${card.name}" dal dispositivo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _deleteCard(card);
    }
  }
}
